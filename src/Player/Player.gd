extends KinematicBody2D

const DAMAGE_SKIN = preload("res://src/GUI/DamageSkin.tscn")

export (int) var run_speed = 300
export (int) var jump_speed = -700
export (int) var gravity = 1200

const LEFT = true
const RIGHT = false

const NPC = 1
const ENEMY = 2
const ITEM = 3

var velocity = Vector2()
var jumping = false

var invincible = false # 현재 플레이어가 무적상태인가 
var is_attack = false # 플레이어의 공격 모션이 끝났는가
var is_delay = false # 공격 딜레이

var player_variable = null #플레이어의 상태
var items = null # 아이템 리스트 
var skills = null # 스킬 리스트 

const SKILL_ATTACK = true 
const NORMAL_ATTACK = false

onready var player_skill_position = $SkillSpawnPosition
onready var player_weapon_position = $WeaponSpawnPosition
onready var player_sprite = $Sprite
onready var player_attack_delay = $AttackDelay
onready var InvincibleTimer = $InvincibleTimer
onready var damage_position = $DamagePosition

signal NOTIFY


# 퀘스트 목록을 기반으로 플레이어가 생성될 떄마다 다시 불러오기?
func load_subject():
	pass

func set_camera_limit():
	var map_limits = get_parent().get_node("TileMap").get_used_rect()
	var map_cellsize = get_parent().get_node("TileMap").cell_size
	$Camera2D.limit_left = map_limits.position.x * map_cellsize.x
	$Camera2D.limit_right = map_limits.end.x * map_cellsize.x
	#$Camera2D.limit_top = map_limits.position.y * map_cellsize.y
	$Camera2D.limit_bottom = map_limits.end.y * map_cellsize.y

func _ready():
	player_variable = get_node("/root/PlayerVariables")
	player_variable.set_player_node_path(self.get_path())
	items = get_node("/root/Items").Items
	set_camera_limit()
	#wear_equipment(0xA002)
	
func _physics_process(delta):
	get_input()
	velocity.y += gravity * delta
	if jumping and is_on_floor():
			jumping = false
	move_and_check_collision()


func get_input():
	velocity.x = 0
	var right = Input.is_action_pressed('RIGHT')
	var left = Input.is_action_pressed('LEFT')
	var jump = Input.is_action_just_pressed('JUMP')
	var attack = Input.is_action_just_pressed("ATTACK")
	var inventory = Input.is_action_just_pressed("open_inventory")
	var state = Input.is_action_just_pressed("open_state")
	var skill = Input.is_action_just_pressed("open_skill")
	var questbox = Input.is_action_just_pressed("open_questbox")

	if jump and is_on_floor():
		jumping = true
		velocity.y = jump_speed
	if not is_attack:
		if left or right:
			player_move(left, right)
		elif inventory:
			open_inventory()
		elif state:
			open_state()
		elif skill:
			open_skill()
		elif questbox:
			open_questbox()

		
	if attack and not is_delay and not is_attack:
		# 기본공격이랑 스킬도 같이 표현
		attack()
	

func player_move(left, right):
	if right:
		set_direction(RIGHT)
		velocity.x += run_speed 
	if left:
		set_direction(LEFT)
		velocity.x -= run_speed
	#velocity.x = lerp(velocity.x, 0, 0.3)
	
func move_and_check_collision():
	velocity = move_and_slide(velocity, Vector2(0, -1))
	#이 부분은 Area2D의 signal로 담당
	"""
	for count in get_slide_count():
		var collision = get_slide_collision(count)
		if collision.collider.is_in_group("enemies"):
			if invincible == true:
				return
			take_damage(collision.collider.collision_attack())
			
		elif collision.collider.is_in_group("spoils"):
			get_spoil(collision.collider)
	"""
	
func open_questbox():
	var questbox_node = player_variable.get_questbox_node()
	if questbox_node != null:
		questbox_node.queue_free()
		return 
	questbox_node = preload("res://src/GUI/QuestListBox.tscn").instance()
	get_node("/root/Main").add_child(questbox_node)
	

func open_skill():
	var skill_instance = player_variable.get_skill_node()
	if skill_instance != null:
		skill_instance.queue_free()
		return 
	skill_instance = preload("res://src/GUI/Skill.tscn").instance()
	skill_instance.connect("upgrade_skill", self, "upgrade_skill")
	get_node("/root/Main").add_child(skill_instance)

func open_state():
	var state_instance = player_variable.get_state_node()
	if state_instance != null:
		state_instance.queue_free()
		return 
	state_instance = preload("res://src/GUI/State.tscn").instance()
	state_instance.connect("upgrade_state", self, "upgrade_state")
	get_node("/root/Main").add_child(state_instance)

func open_inventory():
	var inventory_instance = player_variable.get_inventory_node()
	if inventory_instance != null:
		inventory_instance.queue_free()
		return 
	inventory_instance = preload("res://src/GUI/Inventory.tscn").instance()
	inventory_instance.connect("use_item", self, "use_item")
	get_node("/root/Main").add_child(inventory_instance)

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
		current_weapon["item"].minus_weapon_state_to_player()
		current_weapon["item"].queue_free()
		player_variable.set_current_equipment("weapon", null)
	
	
	player_variable.set_current_equipment("weapon", item["item_scene"])
	current_weapon["item"].set_direction(get_weapon_direction())
	current_weapon["item"].position = player_weapon_position.position
	current_weapon["item"].get_node("AnimationPlayer").connect("animation_finished", self, "_on_attack_motion_finished")
	add_child(current_weapon["item"])
	$AttackDelay.wait_time = current_weapon["item"].get_attack_delay()

func take_damage(damage):
	damage = player_variable.calc_def(damage)
	var temp = {
		"current_hp" : damage
	}
	show_damage(damage)
	player_variable.increase_state_from_effect(temp, -1)
	invincible = true
	InvincibleTimer.start()
	
func show_damage(damage):
	var damage_skin = DAMAGE_SKIN.instance()
	damage_skin.position = damage_position.position
	add_child(damage_skin)
	damage_skin.show_value(damage, false, false)		

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
	var skill_code = null
	# 각 각의 맞는 weapon_type을 기반으로 기본공격 스킬 생성
	if weapon_type == "Sword":
		skill_code = 0xE000
		
	elif weapon_type == "Bow":
		skill_code = 0xE001
		
	elif weapon_type == "Gun":
		skill_code = 0xE002
		
	else:
		return
	set_ready_attack(current_weapon, NORMAL_ATTACK, skill_code)
	
func set_ready_attack(current_weapon:Dictionary, skill_type:bool, skill_code:int):
	var skills = null
	if skill_type == NORMAL_ATTACK:
		skills = get_node("/root/Skills").BasicSkills
	elif skill_type == SKILL_ATTACK:
		skills = get_node("/root/SKills").Skills
	
	var skill_instance = skills[skill_code]["skill_scene"].instance()
	skill_instance.position = player_skill_position.global_position
	get_parent().add_child(skill_instance)
	skill_instance.set_direction(get_weapon_direction())
	skill_instance.set_skill(skill_code, skill_type)
	
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
		
func upgrade_state(state_type):
	var value
	if not player_variable.check_upgrade_point():
		return
	if state_type == "attack":
		value = player_variable.increase_attack()
		
	elif state_type == "def":
		value = player_variable.increase_def()
		
	elif state_type == "crit":
		value = player_variable.increase_crit()
		
	elif state_type == "crit_damage":
		value = player_variable.increase_crit_damage()
		
	elif state_type == "hp":
		value = player_variable.increase_max_hp()
		
	elif state_type == "mp":
		value = player_variable.increase_max_mp()
		
	if value == true:
		player_variable.change_upgrade_point(-1)
		player_variable.update_state()

#################################################### 알림 구간? 
# code기반으로 타입을 얻는다.
func use_item(code, numberof):
	var item = items[code]
	var item_type = item["type"]
	if item_type == "equipment":
	#해당 아이템이 착용중이라면
		if player_variable.check_already_wear_equipment(item["code"]):
			return	
		wear_equipment(code)
	# wear!
	elif item_type == "consumption":
		# 해당 아이템이 존재하는치 체크 
		if not player_variable.check_inventory_item_numberof(item_type, code):
			return
		# 아이템을 사용하는 코드 
		player_variable.use_item(item_type, code, numberof, -1, item["affect_player"])
		send_notifination_to_quest(ITEM, code, numberof * -1)
	elif item_type == "etc":
		return
		
	return


func _on_attack_motion_finished(anim_name:String):
	set_weapon_direction(get_weapon_direction())
	is_attack = false
	

func _on_enemy_death(enemy_exp, enemy_coin, enemy_code):
	#submit.notify()
	#emit_signal("NOTIFY", 2, enemy_code, 1)
	send_notifination_to_quest(ENEMY, enemy_code, 1)
	player_variable.get_exp(enemy_exp)
	player_variable.get_coin(enemy_coin)

func _on_AttackDelay_timeout() -> void:
	is_delay = false
	
# 현재 장착중인 무기는 판매가 금지된다. 
func _on_sell_item(item):
	var item_type = item["type"]
	var item_code = item["code"]
	var numberof = item["numberof"]
	var item_price = items[item_code]["sell"]

	#해당 아이템이 착용중이라면
	if player_variable.check_already_wear_equipment(item["code"]):
		return	

	if not player_variable.check_inventory_item_numberof(item_type, item_code):
		return

	player_variable.use_item(item_type, item_code, numberof, -1, false)
	player_variable.get_coin(item_price)
	send_notifination_to_quest(ITEM, item_code, numberof * -1)
	
func _on_buy_item(item):
	var item_price = items[item["code"]]["buy"]
	if not player_variable.check_player_coin(item_price):
		return
	# 해당 아이템이 이미 있다면
	if player_variable.check_already_has_equipment(item["code"]):
		return
	player_variable.get_coin(-item_price)
	player_variable.get_item(item)
	send_notifination_to_quest(ITEM, item["code"], 1)
	
func upgrade_skill(code):
	var skills = get_node("/root/Skills")
	if not player_variable.check_skill_point():
		return
		
	# 배울려는 스킬의 선행스킬을 찍었는지 
	if not skills.check_precedence(code):
		return
			
	# 스킬을 배운다. 
	skills.upgrade_skill(code)
	player_variable.change_skill_point(-1)
	player_variable.update_skill()
	
func _on_InvincibleTimer_timeout() -> void:
	invincible = false


func _on_Area2D_body_entered(body: Node) -> void:
	if body.is_in_group("enemies"):
		if invincible == true:
			return
		take_damage(body.collision_attack())
			
	elif body.is_in_group("spoils"):
		var item = body.get_item()
		body.queue_free()
		get_spoil(item)
		
	
func get_spoil(item):
	player_variable.get_spoil(item)
	send_notifination_to_quest(ITEM, item["code"], item["numberof"])
		
# quest list box update
func send_notifination_to_quest(type:int, code:int, numberof:int):
	emit_signal("NOTIFY", type, code , numberof)
	player_variable.update_questbox()

func get_quest_reward(reward:Dictionary):
	var reward_exp = reward["state"]["current_exp"]
	var reward_coin = reward["state"]["coin"]
	var items = reward["item"]
	for type_key in items:
		for item in items[type_key]:
			get_spoil(item)
			
	player_variable.get_exp(reward_exp)
	player_variable.get_coin(reward_coin)

# Quest 아이템들을 NPC에게 넘김
func give_item_to_quest(need_items:Array):
	for item in need_items:
		var item_code = item["code"]
		var numberof = item["numberof"]
		var item_type = items[item_code]["type"]
		player_variable.use_item(item_type, item_code, numberof, -1, false) 
		send_notifination_to_quest(ITEM, item_code, numberof * -1)

# 퀘스트를 수락할 시 퀘스트 매니저에 Signal 전송 (기존 아이템 검사) 
func send_signal_abount_inventory_item():
	for type in player_variable.inventory:
		for item_code in player_variable.inventory[type]:
			var numberof = player_variable.inventory[type][item_code]["numberof"]
			send_notifination_to_quest(ITEM, item_code, numberof * 1)





