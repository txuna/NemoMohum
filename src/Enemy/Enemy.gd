extends KinematicBody2D

var velocity = Vector2.ZERO
const GRAVITY = 40

const LEFT = -1
const RIGHT = 1
const STAND = true 
const WALK = false
const direction_list = [LEFT, RIGHT]
const stand_list = [STAND, WALK]
const DEF_VALUE = 500
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

var current_buff_list = {} #현재 몬스터가 적용받고 있는 버프

signal EnemyDeath
signal EnemyAttack

onready var HitEffectPosition = $HitEffectPosition
onready var EnemyCollision = $CollisionShape2D
onready var PlayerDetectionCollision = $AttackArea/CollisionShape2D

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


var texture_list = {
	"def" : load("res://assets/art/icon/enemy_debuff_decrease_def.png"),
	"current_hp" : load("res://assets/art/icon/enemy_debuff_current_hp.png"),
	"speed" : load("res://assets/art/icon/enemy_debuff_decrease_speed.png"),
	"attack" : load("res://assets/art/icon/enemy_debuff_decrease_attack.png"),
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	init_buff_container()
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


"""
[
	{
		"damage" : value, 
		"crit" : value,
		"index" : value,  
	}
]
"""

func calc_damage_using_def(damage_list):
	var index=0
	var calc_damage_list = []
	for value in damage_list:
		calc_damage_list.append(
			{
				"damage" : calc_def(value["damage"]),
				"crit" : value["crit"],
				"index" : value["index"]
			}
		)
		index+=1
	return calc_damage_list
	
	
func take_damage(damage_list, debuff_option):
	if is_enemy_death:
		return 
		
	#$HitAudio.play()
	EnemySprite.play("hit")
	var particle = load("res://src/Effect/HitEffect.tscn").instance()
	particle.position = HitEffectPosition.position
	add_child(particle)
	
	var calc_damage_list = calc_damage_using_def(damage_list)
	show_damage(calc_damage_list)
	
	for value in calc_damage_list:
		var damage = value["damage"]
		var crit = value["crit"]
		var index = value["index"]
		
		#show_damage(damage, crit, index)
		if enemy_info["state"]["current_hp"] - damage <= 0:
			enemy_death()
			return
		else:
			enemy_info["state"]["current_hp"] -= damage
			
		HealthBar.show_damage(enemy_info["state"]["current_hp"])
	
	## debuff내용이 없다면 take_damage 끝
	if debuff_option["is_debuff"] == false:
		return 

	# 현재 같은 타입의 디버프가 걸려있는지 확인  
	# queue_free()하는데 걸리는 시간때문에 기존의 이름을 못 쓰고 새로 추가하려는 노드의 이름에 @@숫자가 붙게 된다.
	if check_debuff(debuff_option["effect"]["type"]):
		# 만약 걸려있다면 해제 
		return #일단 걸리지 않게
		#print("이전의 디버프를 해제 합니다.")
		#_on_debuff_timeout(debuff_option["effect"]["type"])

	# 디버프 설정 
	#print("디버프를 설정합니다.")
	set_debuff(debuff_option)	
		
"""
func take_damage(player_damage, crit, index, debuff_option):
	if is_enemy_death:
		return
	var damage = calc_def(player_damage)
	#$HitAudio.play()
	#HealthBar.show_damage(damage)
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
	if debuff_option["is_debuff"] == false:
		return 

	# 현재 같은 타입의 디버프가 걸려있는지 확인  
	# queue_free()하는데 걸리는 시간때문에 기존의 이름을 못 쓰고 새로 추가하려는 노드의 이름에 @@숫자가 붙게 된다.
	if check_debuff(debuff_option["effect"]["type"]):
		# 만약 걸려있다면 해제 
		return #일단 걸리지 않게
		#print("이전의 디버프를 해제 합니다.")
		#_on_debuff_timeout(debuff_option["effect"]["type"])

	# 디버프 설정 
	#print("디버프를 설정합니다.")
	set_debuff(debuff_option)
"""
func check_debuff(type:String):
	#print("같은 종류의 디버프가 걸린적이 있는지 확인합니다. ")
	if current_buff_list.has(type):
		#print("이미 이전에 같은 종류의 디버프를 건적이 있습니다.")
		return true 
	else:
		#print("이미 이전에 같은 종류의 디버프를 건적이 없습니다.")
		return false

# 디버프 걸기  
func set_debuff(debuff_option:Dictionary):
	var duration = debuff_option["duration"]
	var percent = debuff_option["effect"]["percent"]
	var type = debuff_option["effect"]["type"]
	current_buff_list[type] = percent
	add_buff_in_container(type)
	
	var timer = Timer.new()
	timer.name = type 
	timer.connect("timeout", self, "_on_debuff_timeout", [type, percent])
	timer.one_shot = true 
	timer.wait_time = duration
	add_child(timer)
	timer.start()
	
	# def나 speed, attack은  지속시간동안 한번 
	# current_hp는 지속시간동안 초당 데미지 들어감
	if type == "current_hp": # 1초마다 데미지가 들어간다. 
		var damage_per_second_list = get_node("/root/PlayerVariables").get_player_attack()
		var damage_timer = Timer.new() 
		damage_timer.name = "per_second"+"current_hp"
		damage_timer.connect("timeout", self, "_on_damage_per_second", [damage_per_second_list, percent])
		damage_timer.wait_time = 1
		add_child(damage_timer)
		damage_timer.start() 
		
		
	elif type in ["def", "speed", "attack"]:
		var value = enemy_info["state"][type] 
		value = value - (value * percent / 100)
		enemy_info["state"][type] = value
		#print("Start Debuff Enemy Def : " + str(value))
		
	else:
		print("Isn't exist effect about " + type)
		return

func add_buff_in_container(type):
	var texture = make_texture(type)
	BuffContainer.add_child(texture)
	
	
func remove_buff_in_container(node_name):
	var buff_node = BuffContainer.get_node_or_null(node_name)
	if buff_node:
		buff_node.queue_free()

func _on_damage_per_second(damage_per_second_list:Array, percent:int):
	randomize()
	var damage = rand_range(damage_per_second_list[0], damage_per_second_list[1]) 
	damage = damage + (damage * percent / 100)
	var option = {
		"option" : {
			"is_debuff" : false,
			"duration" : 0,
			"effect" : null,
		},
	}
	#take_damage(damage, false, 1, option["option"])
	take_damage([{
		"damage" : damage,
		"crit" : false, 
		"index" : 1, 
	}], option["option"])

func _on_debuff_timeout(timer_name:String, percent:int):
	var timer_node = get_node_or_null(timer_name)
	if timer_node:
		timer_node.queue_free()
		current_buff_list.erase(timer_name)
		#print("디버프 타이머 노드를 정상적으로 해제 했습니다.")
		remove_buff_in_container("icon"+timer_name)
		
		#실질적인 디버프 해제 부분 
		if timer_name in ["def", "speed", "attack"]:
			var value = enemy_info["state"][timer_name]
			var origin_value = (100 * value) / (100 - percent)
			enemy_info["state"][timer_name] = origin_value
			#print("Fin Debuff Enemy Def : " + str(origin_value))
					
		elif timer_name == "current_hp":
			var damage_timer_node = get_node_or_null("per_second"+timer_name)
			if damage_timer_node == null:
				print("ERROR damage timer node is NULL") 
				return 
			else:
				damage_timer_node.queue_free()
					
	else:
		print("ERROR _on_debuff_timeout : Can't found debuff about " + timer_name)
	
func enemy_death_and_remove_debuff():
	var temp_current_buff_list = current_buff_list.duplicate()
	for debuff_name in temp_current_buff_list:
		_on_debuff_timeout(debuff_name, current_buff_list[debuff_name])

func init_buff_container():
	for buff in BuffContainer.get_children():
		buff.queue_free()	


func make_texture(type:String)->TextureRect:
	var texture_rect = TextureRect.new()
	texture_rect.name = "icon"+type
	texture_rect.texture = texture_list[type]
	return texture_rect
	
	
func calc_def(damage):
	var def_percent = float(enemy_info["state"]["def"]) / (float(enemy_info["state"]["def"]) + DEF_VALUE) * 100.0
	return int(float(damage) * (1.0 - (def_percent / 100.0)))
	
# 지금까지 몬스터에 걸린 디버프 해제
func enemy_death():
	is_attack = false
	is_delay = false
	is_enemy_death = true
	give_spoil()
	emit_signal("EnemyDeath", give_exp(), give_coin(), enemy_info["enemy_code"])
	enemy_death_and_remove_debuff()
	PlayerDetectionCollision.set_deferred("disabled", true)
	EnemyCollision.set_deferred("disabled", true)
	EnemySprite.stop()
	EnemySprite.play("die")
	yield(EnemySprite, "animation_finished") #EnemyPlayer의 animation_finished 시그널을 받으면 다시 실행
	visible = false
	$SpawnTimer.start()
	#queue_free()


func respawn():
	is_enemy_death = false
	visible = true
	EnemyCollision.set_deferred("disabled", false)
	PlayerDetectionCollision.set_deferred("disabled", false)
	var enemy_code = enemy_info["enemy_code"]
	set_enemy_info(enemy_code)

	
"""
func show_damage(damage, crit, index):
	var damage_skin = DAMAGE_SKIN.instance()
	damage_skin.position = EnemyDamagePosition.position
	damage_skin.position.y = EnemyDamagePosition.position.y - (index * 70)
	add_child(damage_skin)
	damage_skin.show_value(damage, crit, true)	
"""


func show_damage(damage_list):
	var damage_skin = DAMAGE_SKIN.instance()
	damage_skin.position = EnemyDamagePosition.position
	add_child(damage_skin)
	damage_skin.show_value2(damage_list)
	
	
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
		




