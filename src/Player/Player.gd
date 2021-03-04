extends KinematicBody2D

export (int) var run_speed = 300
export (int) var jump_speed = -700
export (int) var gravity = 1200

const LEFT = true
const RIGHT = false

var velocity = Vector2()
var jumping = false

var invincible = false # 현재 플레이어가 무적상태인가 
var is_attack = false # 현재 플레이어가 공격쿨타임에 있는가 
var is_delay = false

var player_variable = null
var items = null

onready var player_skill_position = $SkillSpawnPosition
onready var player_weapon_position = $WeaponSpawnPosition
onready var player_sprite = $Sprite
onready var player_attack_delay = $AttackDelay

func set_camera_limit():
	var map_limits = get_parent().get_node("TileMap").get_used_rect()
	var map_cellsize = get_parent().get_node("TileMap").cell_size
	$Camera2D.limit_left = map_limits.position.x * map_cellsize.x
	$Camera2D.limit_right = map_limits.end.x * map_cellsize.x
	#$Camera2D.limit_top = map_limits.position.y * map_cellsize.y
	$Camera2D.limit_bottom = map_limits.end.y * map_cellsize.y

func _ready():
	player_variable = get_node("/root/PlayerVariables")
	#player_variable.set_player_node_path(self.get_path())
	items = get_node("/root/Items").Items
	set_camera_limit()
	wear_equipment(0xA000)
	
func _physics_process(delta):
	get_input()
	velocity.y += gravity * delta
	if jumping and is_on_floor():
			jumping = false
	check_collision()

func get_input():
	velocity.x = 0
	var right = Input.is_action_pressed('RIGHT')
	var left = Input.is_action_pressed('LEFT')
	var jump = Input.is_action_just_pressed('JUMP')
	var attack = Input.is_action_just_pressed("ATTACK")

	if jump and is_on_floor():
		jumping = true
		velocity.y = jump_speed
	if not is_attack:
		player_move(left, right)
		
	if attack and not is_delay:
		# 기본공격이랑 스킬도 같이 표현
		attack()

func player_move(left, right):
	if right:
		set_direction(RIGHT)
		velocity.x += run_speed 
	if left:
		set_direction(LEFT)
		velocity.x -= run_speed
	
	
func check_collision():
	velocity = move_and_slide(velocity, Vector2(0, -1))
	for count in get_slide_count():
		var collision = get_slide_collision(count)
		
	
# 좌유 방향에 따라 플레이어의 scale과 무기 위치를 세팅한다.
func set_direction(direction):
	player_sprite.flip_h = direction
	if direction == LEFT:
		if sign(player_weapon_position.position.x) == 1:
			set_position_of_player()
	elif direction == RIGHT:
		if sign(player_weapon_position.position.x) == -1:
			set_position_of_player()
			
	set_weapon_direction(direction)
			
# 무기와 스킬의 위치를 지정한다. 
func set_position_of_player():
	player_weapon_position.position.x *= -1
	player_skill_position.position.x *= -1

# 해당 코드를 기반으로 어떤 아이템인지 체크 한다. 또한 존재하는 키인지도 확인
func wear_equipment(code:int):
	if not items.has(code):
		return	
	
	var item = items[code]
	var detail_type = item["detail_type"] 
	
	if detail_type == "weapon":
		wear_weapon(item)
		pass
	elif detail_type == "shirt":
		pass
	
# 무기의 방향과 무기가 있어야 할 위치를 설정한다. 
func set_weapon_direction(direction):
	var current_weapon = player_variable.get_current_equipment()["weapon"]
	if current_weapon["item"] == null:
		return 

	current_weapon["item"].set_direction(direction)
	current_weapon["item"].position = player_weapon_position.position
	
func wear_weapon(item):
	var current_weapon = player_variable.get_current_equipment()["weapon"]
	if current_weapon["item"] != null:
		current_weapon["item"].queue_free()
		player_variable.set_current_euipment("weapon", null)
	
	player_variable.set_current_equipment("weapon", item["item_scene"])
	current_weapon["item"].position = player_weapon_position.position
	current_weapon["item"].get_node("AnimationPlayer").connect("animation_finished", self, "_on_attack_motion_finished")
	add_child(current_weapon["item"])
	
# 기본공격의 코드는 0xE000 딕셔너리로 무기마다의 기본공격 체크 
func attack(code=false):
	var current_weapon = player_variable.get_current_equipment()["weapon"]
	if current_weapon["item"] == null:
		return
	# 무기타입에 따른 공격
	if code == false:
		normal_attack(current_weapon)	
	# 스킬공격 
	else:
		skill_attack(current_weapon, code)
		

func skill_attack(current_weapon:Dictionary, code:int):
	pass
	
func normal_attack(current_weapon:Dictionary):
	var weapon_type = current_weapon["item"].get_weapon_type()
	# 각 각의 맞는 weapon_type을 기반으로 기본공격 스킬 생성
	if weapon_type == "Sword":
		pass
		
	elif weapon_type == "Bow":
		pass
		
	elif weapon_type == "Gun":
		pass
		
	else:
		return
	set_ready_attack(current_weapon)
	
func set_ready_attack(current_weapon:Dictionary):
	is_attack = true
	is_delay = true
	player_attack_delay.start()
	if get_weapon_direction() == RIGHT:
		current_weapon["item"].get_node("AnimationPlayer").play("right_attack")
	else:
		current_weapon["item"].get_node("AnimationPlayer").play("left_attack")

# 플레이어의 좌우방향을 얻는 함수
func get_weapon_direction():
	if sign(player_weapon_position.position.x) == 1:
		return RIGHT
	else:
		return LEFT

func _on_attack_motion_finished(anim_name:String):
	set_weapon_direction(get_weapon_direction())
	is_attack = false


func _on_AttackDelay_timeout() -> void:
	is_delay = false
