extends KinematicBody2D

var velocity = Vector2.ZERO
const GRAVITY = 40

const LEFT = -1
const RIGHT = 1
const STAND = true 
const WALK = false
const direction_list = [LEFT, RIGHT]
const stand_list = [STAND, WALK]
const DEF_VALUE = 1000
const DAMAGE_SKIN = preload("res://src/GUI/DamageSkin.tscn")

var current_direction = null
var current_state = null
var enemy_info = null
var items = null
var is_enemy_death = false

var is_delay = false # 다음 공격까지의 딜레이 
var is_attack = false # 공격 애니메이션 시간
var player_in = false
var enemy_skill_scene:String

var current_buff_list = [] #현재 몬스터가 적용받고 있는 버프

signal EnemyDeath
signal EnemyAttack

onready var HitEffectPosition = $HitEffectPosition
onready var EnemyCollision = $CollisionShape2D
onready var EnemySprite = $EnemySprite
onready var HealthBar = $HealthBar
onready var EnemyDamagePosition = $DamageSkin
onready var SpoilPosition = $SpoilPosition
onready var AttackPosition = $AttackPosition
onready var AttackDelay = $AttackDelay
onready var EnemyInfo = $EnemyInfo
onready var SkillPosition = $SkillPosition
onready var CenterPosition = $CenterPosition
onready var BuffContainer = $BuffContainer/HboxContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	items = get_node("/root/Items").Items
	set_direction()
	choice_stand_or_move()


func _physics_process(delta: float) -> void:
	if is_enemy_death:
		return
	velocity.y += GRAVITY
		
	if check_attack():
		attack()
		
	velocity.x = 0
	if not is_attack:
		if current_state == WALK:
			velocity.x = current_direction * enemy_info["state"]["speed"]
	velocity = move_and_slide(velocity, Vector2.UP)


func show_enemy_info():
	EnemyInfo.text = "Lv." + str(enemy_info["state"]["level"]) + " " + enemy_info["enemy_name"]


# Enemy의 정보를 저장한다. 
func set_enemy_info(enemy_code:int):
	enemy_info = EnemyState.new().get_enemy_info(enemy_code)
	HealthBar.set_health(enemy_info["state"]["max_hp"])
	show_enemy_info()
	
# Enemy의 방향을 결정짓는다 
# fixed_direction = Eneny가 player방향으로 바라보아야 할때 고정값으로 수정
func set_direction(fixed_direction:int=0):
	if is_attack:
		return
	if fixed_direction == 0:
		current_direction = get_direction()
	else:
		current_direction = fixed_direction
		
	if current_direction == LEFT:
		EnemySprite.flip_h = false
		if sign(SkillPosition.position.x) == 1:
			SkillPosition.position.x *= -1
	else:
		EnemySprite.flip_h = true
		if sign(SkillPosition.position.x) == -1:
			SkillPosition.position.x *= -1
			
	choice_stand_or_move()
	

# 3초 마다 왼쪽 또는 오른쪽으로 갈지 결정한다. 또한 Area2d를 자식으로 두고 플레이어의 움직임 감지
func _on_Timer_timeout() -> void:
	set_direction()
	

# 움직일지 가만히 있을지 결정
func choice_stand_or_move():
	randomize()
	current_state = stand_list[randi() % stand_list.size()]
	if current_state == STAND:
		EnemySprite.play("idle")
	else:
		EnemySprite.play("walk")
	
	
# 오른쪽으로 갈지 왼쪽으로 갈지 결정
func get_direction():
	randomize()
	var direction = direction_list[randi() % direction_list.size()]
	return direction
	
	
#Enemy의 공격이 아닌 플레이어와 몸통 박치기 
func collision_attack():
	if is_enemy_death:
		return 0
	return enemy_info["state"]["attack"]
	
	
	
func take_damage(player_damage, crit, index, debuff={}):
	if is_enemy_death:
		return
	var damage = calc_def(player_damage)
	#$HitAudio.play()
	HealthBar.show_damage(damage)
	show_damage(damage, crit, index)
	
	if enemy_info["state"]["current_hp"] - damage <= 0:
		enemy_death()
	else:
		EnemySprite.play("hit")
		enemy_info["state"]["current_hp"] -= damage
	
	HealthBar.show_damage(enemy_info["state"]["current_hp"])
		
	var particle = load("res://src/Effect/HitEffect.tscn").instance()
	particle.position = HitEffectPosition.position
	add_child(particle)
	
	## debuff내용이 없다면 take_damage 끝
	if debuff.empty():
		return 

	set_debuff(debuff)

# 디버프 걸기
func set_debuff(debuff:Dictionary):
	pass	
	
	
func calc_def(damage):
	var def_percent = float(enemy_info["state"]["def"]) / (float(enemy_info["state"]["def"]) + DEF_VALUE) * 100.0
	return int(float(damage) * (1.0 - (def_percent / 100.0)))
	
	
func enemy_death():
	is_enemy_death = true
	give_spoil()
	emit_signal("EnemyDeath", give_exp(), give_coin(), enemy_info["enemy_code"])
	EnemyCollision.set_deferred("disabled", true)
	EnemySprite.stop()
	EnemySprite.play("die")
	yield(EnemySprite, "animation_finished") #EnemyPlayer의 animation_finished 시그널을 받으면 다시 실행
	visible = false;
	$SpawnTimer.start()
	#queue_free()


func respawn():
	is_enemy_death = false
	visible = true
	EnemyCollision.set_deferred("disabled", false)
	var enemy_code = enemy_info["enemy_code"]
	set_enemy_info(enemy_code)
	#pass


func show_damage(damage, crit, index):
	var damage_skin = DAMAGE_SKIN.instance()
	damage_skin.position = EnemyDamagePosition.position
	damage_skin.position.y = EnemyDamagePosition.position.y - (index * 30)
	add_child(damage_skin)
	damage_skin.show_value(damage, crit, true)	


func get_hit_position():
	return HitEffectPosition.position
	
	
func give_exp():
	return enemy_info["spoil"]["exp"]
	
	
func give_coin():
	return enemy_info["spoil"]["coin"]
	
	
# Spoil Instance 생성
func give_spoil():
	var index = 1
	for enemy_item in enemy_info["spoil"]["item"]:
		randomize()
		var percentage = rand_range(0, 100)
		
		if percentage <= enemy_item["percentage"]:
			var item = items[enemy_item["code"]]
			var spoil_instance = load("res://src/Spoil/Spoil.tscn").instance()
			spoil_instance.get_node("Sprite").texture = item["item_image"]
			
			spoil_instance.position = SpoilPosition.global_position
			spoil_instance.position.x = SpoilPosition.global_position.x + index
			
			get_parent().call_deferred("add_child", spoil_instance)
			get_tree().call_group("spoils", "connect", spoil_instance)
			
			spoil_instance.setup_item(enemy_item["code"], enemy_item["numberof"], item["type"])
			spoil_instance.connect("GiveSpoil", get_node(get_node("/root/PlayerVariables").get_player_node_path()), "_on_get_spoil")
			index += 40


func set_enemy_direction_to_player():
	var player_position = get_node(get_node("/root/PlayerVariables").get_player_node_path()).global_position.x
	var enemy_position = CenterPosition.global_position.x 
	if enemy_position - player_position > 0:
		set_direction(LEFT)
		EnemySprite.flip_h = false
		return LEFT
	else:
		set_direction(RIGHT)
		EnemySprite.flip_h = true
		return RIGHT

	
func check_attack():
	if is_attack or is_delay or not player_in:
		return false
	else:
		return true
	
	
# 스킬 발동시 player노드와 시그널 Connect
# 플레이어의 방향 체크
func attack():
	AttackDelay.start()
	var direction = set_enemy_direction_to_player()
	is_attack = true
	is_delay = true
	EnemySprite.play("attack")
	var skill_instance = load(enemy_skill_scene).instance()
	skill_instance.position = SkillPosition.global_position
	skill_instance.init(enemy_info["state"]["attack"], direction)
	skill_instance.connect("EnemyAttack", get_node(get_node("/root/PlayerVariables").get_player_node_path()), "_on_take_damage_from_enemy")
	get_parent().get_parent().call_deferred("add_child", skill_instance)
	

func set_skill(skill_scene):
	enemy_skill_scene = skill_scene

func _on_AttackDelay_timeout() -> void:
	is_delay = false


func _on_EnemySprite_animation_finished() -> void:
	if EnemySprite.animation == "attack" or EnemySprite.animation == "hit":
		is_attack = false
		set_direction()
		choice_stand_or_move()
		
func _on_player_death():
	player_in = false


func _on_AttackArea_body_entered(body: Node) -> void:
	if is_enemy_death:
		return
	if body.name == "Player":
		player_in = true


func _on_AttackArea_body_exited(body: Node) -> void: 
	if body.name == "Player":
		player_in = false


func add_buff(code:int):
	var enchant_list = EnchantList.new() 
	var skill = enchant_list.get_enchant(code)
	
	# 스킬이 버프형인지 즉발형인지 체크 
	
	# 버프형일 때 값이 고정값인지 퍼센트값인지 또한 Timer체크
	
func remove_buff(code:int):
	pass



