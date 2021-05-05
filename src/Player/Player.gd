extends KinematicBody2D

const DAMAGE_SKIN = preload("res://src/GUI/DamageSkin.tscn")

export (int) var run_speed = 300
export (int) var jump_speed = 700
export (int) var gravity = 1200

const LEFT = true
const RIGHT = false

const NPC = 1
const ENEMY = 2
const ITEM = 3

var velocity = Vector2()

var invincible = false # 현재 플레이어가 무적상태인가 
var is_attack = false # 플레이어의 공격 모션이 끝났는가
var is_delay = false # 공격 딜레이

var player_variable = null #플레이어의 상태
var items = null # 아이템 리스트 
var skills = null # 스킬 리스트 
var is_death = false

const SKILL_ATTACK = true 
const NORMAL_ATTACK = false

onready var player_skill_position = $SkillSpawnPosition
onready var player_weapon_position = $WeaponSpawnPosition
onready var player_animated_sprite = $AnimatedSprite
onready var player_attack_delay = $AttackDelay
onready var InvincibleTimer = $InvincibleTimer
onready var damage_position = $DamagePosition
onready var player_shirt_position = $ShirtSpawnPosition
onready var player_hat_position = $HatSpawnPosition
onready var player_skill_effect_position = $EffectPosition

signal NOTIFY

signal BUFF_SWITCH

var equipment_position_list = {

}


func set_camera_limit():
	var map_limits = get_parent().get_node("TileMap").get_used_rect()
	var map_cellsize = get_parent().get_node("TileMap").cell_size
	$Camera2D.limit_left = map_limits.position.x * map_cellsize.x
	$Camera2D.limit_right = map_limits.end.x * map_cellsize.x
	#$Camera2D.limit_top = map_limits.position.y * map_cellsize.y
	$Camera2D.limit_bottom = map_limits.end.y * map_cellsize.y + 64 + 32 + 16 + 8

func _ready():
	player_variable = get_node("/root/PlayerVariables")
	player_variable.set_player_node_path(self.get_path())
	items = get_node("/root/Items").Items
	load_position()
	set_camera_limit()
	setup_player()
	
	
func load_position():
	equipment_position_list["Sword"] = player_weapon_position
	equipment_position_list["Gun"] = player_weapon_position
	equipment_position_list["Bow"] = player_weapon_position
	equipment_position_list["shirt"] = player_shirt_position
	equipment_position_list["hat"] = player_hat_position
	
func _physics_process(delta):
	get_input()
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2(0, -1))

func _on_player_action(type:String):
	velocity.x = 0
	if type == "Right":
		player_move(false, true)
	if type == "Left":
		player_move(true, false)
	if type == "Inventory":
		open_inventory()
	if type == "State":
		open_state()
	if type == "Skill":
		open_skill()
	if type == "Quest":
		open_questbox()
	if type == "Jump" and is_on_floor():
		velocity.y -= jump_speed
		player_animated_sprite.play("jump")
	if type == "Attack" and not is_delay and not is_attack:
		attack(false)
	if type == "Stop":
		player_move(false, false)
		
	if type == "A":
		check_quick_slot(true, false, false, false)
		
	if type == "B":
		check_quick_slot(false, true, false, false)
		
	if type == "C":
		check_quick_slot(false, false, true, false)
		
	if type == 'D':
		check_quick_slot(false, false, false, true)
	

func get_input():
	velocity.x = 0
	if is_death:
		return
	var right = Input.is_action_pressed('RIGHT')
	var left = Input.is_action_pressed('LEFT')
	var jump = Input.is_action_just_pressed('JUMP')
	var attack = Input.is_action_just_pressed("ATTACK")
	var inventory = Input.is_action_just_pressed("open_inventory")
	var state = Input.is_action_just_pressed("open_state")
	var skill = Input.is_action_just_pressed("open_skill")
	var questbox = Input.is_action_just_pressed("open_questbox")
	var a_button = Input.is_action_just_pressed("A_Button")
	var b_button = Input.is_action_just_pressed("B_Button")
	var c_button = Input.is_action_just_pressed("C_Button")
	var d_button = Input.is_action_just_pressed("D_Button")

	if left or right:
		player_move(left, right)
	if inventory:
		open_inventory()
	if state:
		open_state()	
	if skill:
		open_skill()	
	if questbox:
		open_questbox()
		
	if jump and is_on_floor():
		velocity.y -= jump_speed
		player_animated_sprite.play("jump")

	if not is_delay and not is_attack:
		if attack:
			attack(false)
			
	check_quick_slot(a_button, b_button, c_button, d_button)
		
func player_move(left, right):	
	if is_on_floor() and not is_attack:
		player_animated_sprite.play("walk")
		
	if right:
		set_direction(RIGHT)
		velocity.x += run_speed 
		
	elif left:
		set_direction(LEFT)
		velocity.x -= run_speed

# type을 보고 consumption이라면 그냥쓰고, skill이라면 is_attack이랑 is_delay체크
func check_quick_slot(a_button, b_button, c_button, d_button):
	if a_button:
		do_quick_slot("A")
		
	if b_button:
		do_quick_slot("B")
		
	if c_button:
		do_quick_slot("C")
		
	if d_button:
		do_quick_slot("D")
		
func do_quick_slot(input_value:String):
	var quick_slot_value = player_variable.quick_slot[input_value]
	if quick_slot_value["use"] == false:
		return 
		
	if quick_slot_value["type"] == "consumption":
		use_item(quick_slot_value["code"], 1)
		
	elif quick_slot_value["type"] == "skill":
		if not is_attack and not is_delay:
			attack(true, quick_slot_value["code"])
		else:
			return
	
# 플레이어가 소환될 때 장착중이였던 무기들 다시 착용
func setup_player():	
	var current_equipment = player_variable.get_current_equipment()
	for equipment in current_equipment:
		if current_equipment[equipment]["item"] != null:
			var item = current_equipment[equipment]["item"]
			var item_code = item.get_code()
			wear_equipment(item_code)
	
func open_questbox():
	var questbox_node = player_variable.get_questbox_node()
	if questbox_node != null:
		questbox_node.queue_free()
		return 
	questbox_node = load("res://src/GUI/QuestListBox.tscn").instance()
	get_node("/root/Main").add_child(questbox_node)
	

func open_skill():
	var skill_instance = player_variable.get_skill_node()
	if skill_instance != null:
		skill_instance.queue_free()
		return 
	skill_instance = load("res://src/GUI/Skill.tscn").instance()
	skill_instance.connect("upgrade_skill", self, "upgrade_skill")
	get_node("/root/Main").add_child(skill_instance)

func open_state():
	var state_instance = player_variable.get_state_node()
	if state_instance != null:
		state_instance.queue_free()
		return 
	state_instance = load("res://src/GUI/State.tscn").instance()
	state_instance.connect("upgrade_state", self, "upgrade_state")
	get_node("/root/Main").add_child(state_instance)

func open_inventory():
	var inventory_instance = player_variable.get_inventory_node()
	if inventory_instance != null:
		inventory_instance.queue_free()
		return 
	inventory_instance = load("res://src/GUI/Inventory.tscn").instance()
	inventory_instance.connect("use_item", self, "use_item")
	get_node("/root/Main").add_child(inventory_instance)

# 좌유 방향에 따라 플레이어의 scale과 무기 위치를 세팅한다.
func set_direction(direction):
	player_animated_sprite.flip_h = direction
	if direction == LEFT:
		player_animated_sprite.position = Vector2(13, 1.2)
		if sign(player_weapon_position.position.x) == 1:
			set_position_of_player()
	elif direction == RIGHT:
		player_animated_sprite.position = Vector2(-20, 1.2)
		if sign(player_weapon_position.position.x) == -1:
			set_position_of_player()
			
	set_equipment_direction(direction)
			
# 무기와 스킬의 위치를 지정한다. 
func set_position_of_player():
	player_weapon_position.position.x *= -1
	player_skill_position.position.x *= -1

# 장비를 벗는다.
func take_off_equipment(code:int):
	var detail_type = items[code]["detail_type"]
	var item_type
	if detail_type == "weapon":
		item_type = detail_type
		
	elif detail_type == "armor":
		item_type = items[code]["armor_type"]
	else:
		return 
	
	var current_equipment = player_variable.get_current_equipment()[item_type]
	# 벗어야할 아이템이 이미 null이라면
	if current_equipment["item"] == null:
		return
		
	if item_type == "weapon":
		current_equipment["item"].minus_weapon_state_to_player()
	else:
		current_equipment["item"].minus_armor_state_to_player()
		
	current_equipment["item"].queue_free()
	player_variable.set_current_equipment(item_type, null)
		

# 해당 코드를 기반으로 어떤 아이템인지 체크 한다. 또한 존재하는 키인지도 확인
func wear_equipment(code:int):
	if not items.has(code):
		return	
	
	var item = items[code]
	var detail_type = item["detail_type"] 
	
	if detail_type == "weapon":
		wear_weapon(item)
		
	elif detail_type == "armor":
		wear_armor(item)

	
# 무기의 방향과 무기가 있어야 할 위치를 설정한다. 
func set_equipment_direction(direction):
	var current_equipment = player_variable.get_current_equipment()
	for equipment in current_equipment:
		if current_equipment[equipment]["item"] != null:
			var item = current_equipment[equipment]["item"]	
			item.set_direction(direction)
			var equipment_type = item.get_type()
			item.position = equipment_position_list[equipment_type].position


#먼저 해당 item의 armor_type을 가져옴 
#해당 armor_type을 현재 착용중인지 확인
#착용중이라면 free 
#그렇지 않다면 객체생성후 set_direction후 ShirtSpawnPosition에 설정
func wear_armor(item):
	var current_armor = null
	var armor_type = item["armor_type"]
	current_armor = player_variable.get_current_equipment()[armor_type]
	if current_armor["item"] != null:
		current_armor["item"].minus_armor_state_to_player()
		current_armor["item"].queue_free()
		player_variable.set_current_equipment(armor_type, null)
	
	player_variable.set_current_equipment(armor_type, item["item_scene"])
	current_armor["item"].set_direction(get_equipment_direction())
	current_armor["item"].position = equipment_position_list[armor_type].position
	add_child(current_armor["item"])
	
func wear_weapon(item):
	var current_weapon = player_variable.get_current_equipment()["weapon"]
	if current_weapon["item"] != null:
		current_weapon["item"].minus_weapon_state_to_player()
		current_weapon["item"].queue_free()
		player_variable.set_current_equipment("weapon", null)
	
	
	player_variable.set_current_equipment("weapon", item["item_scene"])
	current_weapon["item"].set_direction(get_equipment_direction())
	current_weapon["item"].position = player_weapon_position.position
	current_weapon["item"].get_node("AnimationPlayer").connect("animation_finished", self, "_on_attack_motion_finished")
	add_child(current_weapon["item"])
	#$AttackDelay.wait_time = current_weapon["item"].get_attack_delay()
	player_attack_delay.wait_time = current_weapon["item"].get_attack_delay()

func take_damage(damage):
	damage = player_variable.calc_def(damage)
	var temp = {
		"current_hp" : damage
	}
	show_damage(damage)
	player_variable.increase_state_from_effect(temp, -1)
	invincible = true
	InvincibleTimer.start()
	if player_variable.get_current_hp() <= 0:
		is_death = true 
		player_animated_sprite.play("die")
	
func show_damage(damage):
	var damage_skin = DAMAGE_SKIN.instance()
	damage_skin.position = damage_position.position
	add_child(damage_skin)
	damage_skin.show_value(damage, false, false)		

# 기본공격의 코드는 0xE000 딕셔너리로 무기마다의 기본공격 체크 
# 해당 어택은 기본 공격
func attack(is_skill, code=0):
	var current_weapon = player_variable.get_current_equipment()["weapon"]
	if current_weapon["item"] == null:
		player_variable.msg_log_update("무기를 착용하고 있지 않습니다.")
		return
	# 무기타입에 따른 공격
	if is_skill == false:
		normal_attack()	
	# 스킬공격 
	else:
		skill_attack(code)
		

func skill_attack(code:int):
	var current_weapon = player_variable.get_current_equipment()["weapon"]
	var skill = get_node("/root/Skills").Skills[code]
	# 자신이 착용하고 있는 무기와 스킬의 타입과 비교
	if current_weapon["item"].get_type() != skill["type"]:
		player_variable.msg_log_update("스킬타입과 무기 종류가 일치하지 않습니다.")
		return
	else:
		set_ready_attack(SKILL_ATTACK, code)
	return
	
func normal_attack():
	var current_weapon = player_variable.get_current_equipment()["weapon"]
	var weapon_type = current_weapon["item"].get_type()
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
	set_ready_attack(NORMAL_ATTACK, skill_code)
	
# 기본공격이랑 Active 스킬은 이펙트 씬과  스킬 씬을 갖는다.
# 버프는 이펙트 씬만 출력한다. 공격 씬은 존재 X 
# 패시브 스킬은 스킬 업그레이드할 때 적용
# 또한 마나 체크
func set_ready_attack(skill_type:bool, skill_code:int):
	var skills = null
	if skill_type == NORMAL_ATTACK:
		skills = get_node("/root/Skills").BasicSkills
	elif skill_type == SKILL_ATTACK:
		skills = get_node("/root/Skills").Skills
	
	var skill = skills[skill_code]
	# 해당 스킬을 배웠는지 확인
	if skill["acquire"] == false:
		return
	#MP 체크
	if not player_variable.check_mp(skill["mp"]):
		player_variable.msg_log_update("스킬을 사용하기 위한 MP가 부족합니다.")
		return

	#Active의 경우 스킬 인스턴스를 만든다. 몬스터가 맞을 때는 스킬 데미지에 스킬 레벨만큼 곱해서 함
	if skill["skill_type"] == "Active":
		var skill_instance = skill["skill_scene"].instance()
		skill_instance.position = player_skill_position.global_position
		get_parent().add_child(skill_instance)
		skill_instance.set_direction(get_equipment_direction())
		skill_instance.set_skill(skill_code, skill_type, player_variable.state)
		
	#그리고 현재 이미 버프 수행중이라면 ~~ 체크 필수
	elif skill["skill_type"] == "Buff":
		# 해당 버프가 이미 진행중이라면 
		if player_variable.check_buff(skill["skill_code"]):
			return 
			
		var buff_duration_node = Timer.new()
		buff_duration_node.name = skill["skill_name"]
		buff_duration_node.connect("timeout", self, "_on_buff_duration_finished", [skill["skill_code"], skill["skill_name"]])
		buff_duration_node.one_shot = true 
		buff_duration_node.wait_time = skill["buff_duration"]
		# 플레이어의 해당 버프 진행중임을 알린다. 
		player_variable.add_buff_to_state(skill["skill_code"])
		add_child(buff_duration_node)
		buff_duration_node.start()
		
		# BuffList에게 Signal 전송
		emit_signal("BUFF_SWITCH", true, skill_code) 
	
	#MP 소모 
	player_variable.increase_state_from_effect({"current_mp" : skill["mp"]}, -1)
		
	# 스킬 이펙트 설정
	var skill_effect = skill["skill_effect"]
	if skill_effect != null:
		var skill_effect_instance = skill["skill_effect"].instance()
		skill_effect_instance.position = player_skill_effect_position.position
		add_child(skill_effect_instance)

	is_attack = true
	is_delay = true
	player_attack_delay.start()
	
	var current_weapon = player_variable.get_current_equipment()["weapon"]
	if get_equipment_direction() == RIGHT:
		current_weapon["item"].get_node("AnimationPlayer").play("right_attack")
	else:
		current_weapon["item"].get_node("AnimationPlayer").play("left_attack")


# 플레이어의 좌우방향을 얻는 함수
func get_equipment_direction():
	if sign(player_weapon_position.position.x) == 1:
		return RIGHT
	else:
		return LEFT
		
func upgrade_state(state_type):
	var value
	if not player_variable.check_upgrade_point():
		player_variable.msg_log_update("스탯을 찍기위한 포인트가 부족합니다.")
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
		#해당 아이템이 착용중이라면 벗게 한다.
		if player_variable.check_already_wear_equipment(item["code"]):
			take_off_equipment(code)
			return
		# 그렇지 않다면 입는다. 
		wear_equipment(code)
		return

	elif item_type == "consumption":
		# 해당 아이템이 존재하는치 체크 
		if not player_variable.check_inventory_item_numberof(item_type, code):
			return
		# 아이템을 사용하는 코드 
		player_variable.use_item(item_type, code, numberof, -1, item["affect_player"])
		send_notifination_to_quest(ITEM, code, numberof * -1)
	elif item_type == "etc":
		if not player_variable.check_inventory_item_numberof(item_type, code):
			return 
		player_variable.use_item(item_type, code, numberof, -1, false)
		
	return

# 버프의 지속시간이 끝나면
func _on_buff_duration_finished(skill_code:int, timer_name:String):
	player_variable.remove_buff_to_state(skill_code)
	get_node(timer_name).queue_free()
	emit_signal("BUFF_SWITCH", false, skill_code) 
	# BuffList에게 remove signal 전송

func _on_attack_motion_finished(anim_name:String):
	set_equipment_direction(get_equipment_direction())
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
		player_variable.msg_log_update("해당 장비를 착용중이기에 판매할 수 없습니다.")
		return	

	if not player_variable.check_inventory_item_numberof(item_type, item_code):
		return

	player_variable.use_item(item_type, item_code, numberof, -1, false)
	player_variable.get_coin(item_price)
	send_notifination_to_quest(ITEM, item_code, numberof * -1)
	

func _on_buy_item(item):
	var item_price = items[item["code"]]["buy"]
	if not player_variable.check_player_coin(item_price):
		player_variable.msg_log_update("돈이 부족합니다")
		return
	# 해당 아이템이 이미 있다면
	if player_variable.check_already_has_equipment(item["code"]):
		player_variable.msg_log_update("이미 해당 아이템을 가지고 있습니다.")
		return
	player_variable.get_coin(-item_price)
	player_variable.get_item(item)
	send_notifination_to_quest(ITEM, item["code"], 1)
	
func upgrade_skill(code):
	var skills = get_node("/root/Skills")
	if not player_variable.check_skill_point():
		return
		
	# 이미 해당 스킬이 만렙인지 확인
	if not skills.check_master_level(code):
		player_variable.msg_log_update("이미 해당 스킬은 최대레벨입니다.")
		return
	
	# 배울려는 스킬의 선행스킬을 찍었는지 
	if not skills.check_precedence(code):
		player_variable.msg_log_update("해당 스킬의 선행스킬을 배우지 않았습니다.")
		return
			
	# 스킬을 배운다. 
	skills.upgrade_skill(code)
	player_variable.change_skill_point(-1)
	player_variable.update_skill()
	
func _on_InvincibleTimer_timeout() -> void:
	invincible = false

## 원래는 몬스터 접근과 전리품 흭득을 여기서 했으나 각 각 spoil와 enemy에서 접근
func _on_Area2D_body_entered(body: Node) -> void:
	if is_death:
		return
	#if body.is_in_group("enemies"):
	#	if invincible == true:
	#		return
	#	take_damage(body.collision_attack())
			
	#if body.is_in_group("spoils"):
	#	var item = body.get_item()
	#	body.queue_free()
	#	get_spoil(item)
		
	
func get_spoil(item):
	player_variable.get_spoil(item)
	send_notifination_to_quest(ITEM, item["code"], item["numberof"])
		
# quest list box update
func send_notifination_to_quest(type:int, code:int, numberof:int):
	emit_signal("NOTIFY", type, code , numberof)
	player_variable.update_questbox()

func get_quest_reward(reward:Dictionary):
	player_variable.msg_log_update("퀘스트를 달성했습니다.")
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


func _on_AnimatedSprite_animation_finished() -> void:
	if is_on_floor() and not is_attack:
		player_animated_sprite.play("idle")
	else:
		player_animated_sprite.play("jump")

func _on_take_damage_from_enemy(enemy_damage:int)->void:
	if is_death or invincible:
		return
	else:
		take_damage(enemy_damage)
	
func _on_get_spoil(item)->void:
	if is_death:
		return
	get_spoil(item)

