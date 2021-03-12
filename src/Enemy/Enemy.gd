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
var is_attack = false

signal EnemyDeath

onready var HitEffectPosition = $HitEffectPosition
onready var EnemyCollision = $CollisionShape2D
onready var EnemySprite = $EnemySprite
onready var HealthBar = $HealthBar
onready var EnemyDamagePosition = $DamageSkin
onready var SpoilPosition = $SpoilPosition
onready var EnemyPlayer = $EnemySprite/AnimationPlayer
onready var AttackPosition = $AttackPosition
onready var AttackDelay = $AttackDelay

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	items = get_node("/root/Items").Items
	set_direction()
	choice_stand_or_move()
	#

func _physics_process(delta: float) -> void:
	if is_enemy_death:
		return
	velocity.y += GRAVITY
	if current_state == WALK:
		velocity.x = current_direction * enemy_info["state"]["speed"]
	else:
		velocity.x = 0
	velocity = move_and_slide(velocity, Vector2.UP)

# Enemy의 정보를 저장한다. 
func set_enemy_info(enemy_code:int):
	enemy_info = EnemyState.new().get_enemy_info(enemy_code)
	
	#enemy_info = get_node("/root/EnemyState").EnemyList[enemy_code].duplicate()
	HealthBar.set_health(enemy_info["state"]["max_hp"])
	
# Enemy의 방향을 결정짓는다
func set_direction():
	current_direction = get_direction()
	if current_direction == LEFT:
		EnemySprite.flip_h = false
		if sign(AttackPosition.position.x) == 1:
			AttackPosition.position.x *= -1
	else:
		EnemySprite.flip_h = true
		if sign(AttackPosition.position.x) == -1:
			AttackPosition.position.x *= -1
			
	choice_stand_or_move()

# 3초 마다 왼쪽 또는 오른쪽으로 갈지 결정한다. 또한 Area2d를 자식으로 두고 플레이어의 움직임 감지
func _on_Timer_timeout() -> void:
	set_direction()

# 움직일지 가만히 있을지 결정
func choice_stand_or_move():
	current_state = stand_list[randi() % stand_list.size()]
	if current_state == STAND:
		EnemySprite.animation = "stand"
		EnemyPlayer.play("stand")
	else:
		EnemySprite.animation = "walk"
		EnemyPlayer.play("walk")
	
# 오른쪽으로 갈지 왼쪽으로 갈지 결정
func get_direction():
	var direction = direction_list[randi() % direction_list.size()]
	return direction
	
#Enemy의 공격이 아닌 플레이어와 몸통 박치기 
func collision_attack():
	if is_enemy_death:
		return 0
	return enemy_info["state"]["attack"]
	
func take_damage(player_damage, crit, index):
	if is_enemy_death:
		return
	var damage = calc_def(player_damage)
	#$HitAudio.play()
	HealthBar.show_damage(damage)
	show_damage(damage, crit, index)
	if enemy_info["state"]["current_hp"] - damage <= 0:
		enemy_death()
	else:
		EnemySprite.animation = "hit"
		EnemyPlayer.play("hit")
		enemy_info["state"]["current_hp"] -= damage
		
	var particle = preload("res://src/Effect/HitEffect.tscn").instance()
	particle.position = HitEffectPosition.position
	add_child(particle)
	
	
func calc_def(damage):
	var def_percent = float(enemy_info["state"]["def"]) / (float(enemy_info["state"]["def"]) + DEF_VALUE) * 100.0
	return int(float(damage) * (1.0 - (def_percent / 100.0)))
	
func enemy_death():
	is_enemy_death = true
	give_spoil()
	emit_signal("EnemyDeath", give_exp(), give_coin())
	EnemyCollision.set_deferred("disabled", true)
	EnemySprite.animation = "die"
	EnemyPlayer.play("die")
	yield(EnemyPlayer, "animation_finished")
	queue_free()

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
		var percentage = rand_range(0, 100)
		if percentage <= enemy_item["percentage"]:
			var item = items[enemy_item["code"]]
			var spoil_instance = preload("res://src/Spoil/Spoil.tscn").instance()
			spoil_instance.get_node("Sprite").texture = item["item_image"]
			spoil_instance.position = SpoilPosition.global_position
			spoil_instance.position.x = SpoilPosition.global_position.x + index
			get_parent().call_deferred("add_child", spoil_instance)
			get_tree().call_group("spoils", "connect", spoil_instance)
			spoil_instance.setup_item(enemy_item["code"], enemy_item["numberof"])
			index += 40


func _on_Player_entered_attack_range(body: Node) -> void:
	if is_attack:
		return
	skill_attack()

func skill_attack():
	is_attack = true
	AttackDelay.start()

func _on_AttackDelay_timeout() -> void:
	is_attack = false
