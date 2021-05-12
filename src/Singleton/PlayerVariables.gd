extends Node

const DEF_VALUE = 1000

var current_equipment = {
	"weapon" : {
		"item" : null,
	},
	"shirt" : {
		"item" : null,
	},
	"hat" : {
		"item" : null,
	},
	"gloves" : {
		"item" : null,
	},
	"shoes" : {
		"item" : null,
	},
	"earing" : {
		"item" : null
	},
	"necklace" : {
		"item" : null,
	},
}

var state = {
	"nickname" : "스페셜땡스루",
	"min_attack" : 5, 
	"max_attack" : 12, 
	"current_hp" : 1000, 
	"max_hp" : 1000, 
	"current_mp" : 100,
	"max_mp" : 100,
	"crit" : 1, 
	"crit_damage" : 1, 
	"coin" : 3000,
	"level" : 1,
	"current_exp" : 0, 
	"max_exp" : 1000,
	"upgrade_point" : 10,
	"def" : 100,
	"image" : load("res://assets/art/player/player_new.png"),
	"skill_point" : 50,
	"buff_code_list" : [], #현재 적용받고 있는 버프 스킬 코드
}


var enchant_table = {
	0xA001 : {
		"state_option" : [0x1000, 0x1001],
	}
}

var inventory = {
	"equipment" : {
		0xA001:{
			"code" : 0xA001,
			"numberof" : 1,
			"is_enchant" : true,
		},
		0xA002:{
			"code" : 0xA002,
			"numberof" : 1,
			"is_enchant" : false,
		},
		0xA003:{
			"code" : 0xA003,
			"numberof" : 1,
			"is_enchant" : false,
		},
		0xA004:{
			"code" : 0xA004,
			"numberof" : 1,
			"is_enchant" : false,
		},
		0xA005: {
			"code" : 0xA005,
			"numberof" : 1,
			"is_enchant" : false,
		},
		0xA030:{
			"code" : 0xA030,
			"numberof" : 1,
			"is_enchant" : false,
		},
		0xA031:{
			"code" : 0xA031,
			"numberof" : 1,
			"is_enchant" : false,
		}
	},
	"consumption" : {
		0xB000:{
			"code" : 0xB000,
			"numberof" : 20,
			"is_enchant" : false,
		},
	},
	"etc" : {
		0xC000:{
			"code" : 0xC000,
			"numberof" : 1,
			"is_enchant" : false,
		},
		0x3000 : {
			"code" : 0x3000,
			"numberof" : 3,
			"is_enchant" : false,
		}
	},
}

var quick_slot = {
	"A" : {
		"use" : false, 
		"type" : null,
		"code" : null, 
	},
	"B" : {
		"use" : false, 
		"type" : null,
		"code" : null, 
	},
	"C" : {
		"use" : false, 
		"type" : null,
		"code" : null, 
	},
	"D" : {
		"use" : false, 
		"type" : null,
		"code" : null, 
	},
}

var player_node_path = null

func get_msg_log_node():
	var msg_log_instance = get_node_or_null("/root/Main/MsgLog")
	return msg_log_instance
	
func msg_log_update(msg:String):
	var msg_log_instance = get_msg_log_node()
	if msg_log_instance == null:
		return
	else:
		msg_log_instance.add_message(msg)

func get_mobile_touch_node():
	var mobile_touch_instance = get_node_or_null("/root/Main/MobileTouch")
	return mobile_touch_instance
		
func mobile_touch_update():
	var mobile_touch_instance =  get_mobile_touch_node()
	if mobile_touch_instance == null:
		return 
	else:
		mobile_touch_instance.update_screen()

func get_quick_slot():
	return quick_slot
	
#터치 부분 업데이트 
func set_quick_slot(slot_key:String, code:int, type:String):
	msg_log_update("퀵슬롯에 등록했습니다")
	quick_slot[slot_key]["code"] = code 
	quick_slot[slot_key]["use"] = true 
	quick_slot[slot_key]["type"] = type 

	#quick slot node Update
	mobile_touch_update()

# skill_code에 대한 버프가 현재 적용받고 있는 상태인지 아닌지 확인한다. 
func check_buff(skill_code:int):
	if skill_code in state["buff_code_list"]:
		return true
	else:
		return false

# increase_state_from_effect(effects, mask)	
# 각 버프를 더할 때 버프의 능력치만큼 스탯에 더함
func add_buff_to_state(skill_code:int):
	if check_buff(skill_code):
		return 
	
	var skill = get_node("/root/Skills").Skills[skill_code]
	var skill_level = skill["skill_level"]
	var skill_effect = skill["level_effect"]
	increase_state_from_effect(skill_effect, 1)
	state["buff_code_list"].append(skill_code)
	
func remove_buff_to_state(skill_code:int):
	if not check_buff(skill_code):
		return

	var skill = get_node("/root/Skills").Skills[skill_code]
	var skill_level = skill["skill_level"]
	var skill_effect = skill["level_effect"]
	increase_state_from_effect(skill_effect, -1)
	state["buff_code_list"].erase(skill_code)

func check_mp(mp:int):
	if state["current_mp"] - mp >= 0:
		return true 
	else:
		return false

func exist_key_check(dict, key):
	if dict.has(key):
		return true
	else:
		return false
		
func check_inventory_item_numberof(type, code):
	if not inventory[type].has(code):
		return false
		
	if inventory[type][code]["numberof"] <= 0:
		return false
	return true
	
	
# 인벤토리의 아이템 넘버를 변경하거나 0인것을 없앤다.  mark은 1면 increase, -1 decrease
func change_inventory_item_number(type, code, numberof, mark):	
	if mark == -1:
		if check_inventory_item_numberof(type, code):
			inventory[type][code]["numberof"] += (numberof * mark)
			if inventory[type][code]["numberof"] <= 0:
				inventory[type].erase(code)
		
	elif mark == 1:
		if check_inventory_item_numberof(type, code):
			inventory[type][code]["numberof"] += (numberof * mark)
		else:
			inventory[type][code] = {
				"code" : code,
				"numberof" : numberof,
				"is_enchant" : false,
			}
				
	update_inventory()
	update_shop()
	
func use_item(type, code, numberof, mark, affect_player):
	if affect_player == true:
		var effect = get_node("/root/Items").Items[code]["effect"]
		increase_state_from_effect(effect, 1)
		# 해당 아이템이 장비 이면서 인챈트 되어 있다면 

	if inventory[type][code]["is_enchant"] == true:
		if enchant_table.has(code):
			enchant_table.erase(code)
		inventory[type][code]["is_enchant"] = false
		
	change_inventory_item_number(type, code, numberof, mark)
		
		
func check_skill_point():
	if state["skill_point"] <= 0:
		return false
	return true
	
func change_skill_point(value):
	state["skill_point"] += value	
		
func get_skill_node():
	var skill_instance = get_node_or_null("/root/Main/Skill")
	return skill_instance
	
func update_skill():
	var skill_instance = get_skill_node()
	if skill_instance == null:
		return 
	else:
		skill_instance.update_skill()		
		
func get_state_node():
	var state_instance = get_node_or_null("/root/Main/State")
	return state_instance
		
func update_state():
	var state_instance = get_state_node()
	if state_instance == null:
		return 
	else:
		state_instance.update_state()

		
# 인벤토리가 열려있는지 체크 및 반환
func get_inventory_node():
	var inventory_instance = get_node_or_null("/root/Main/Inventory")
	return inventory_instance
		

func update_inventory():
	var inventory_instance = get_inventory_node()
	if inventory_instance == null:
		return 
	else:
		inventory_instance.load_slot_from_inventory()
			
func get_questbox_node():
	var questbox_node = get_node_or_null("/root/Main/QuestListBox")
	return questbox_node

func update_questbox():
	var questbox_node = get_questbox_node()
	if questbox_node == null:
		return 
	else:
		questbox_node.load_quest_list()		
		
func get_shop_node():
	var shop_node = get_node_or_null("/root/Main/Shop")
	return shop_node
	
func update_shop():
	var shop_node = get_shop_node()
	if shop_node == null:
		return
	else:
		shop_node.update_shop()

		
func get_coin(coin):
	state["coin"] += coin
	msg_log_update(str(coin) + "코인을 얻었습니다.")
	update_inventory()
	update_shop()


func get_hud_node():
	var hud_instance = get_node_or_null("/root/Main/HUD")
	return hud_instance

func update_hud(value, type):
	var hud_instance = get_hud_node()
	if hud_instance == null:
		return 
	else:
		hud_instance.update_hud(value, type)
	
func get_exp(exp_value):
	calc_exp(exp_value)
	

func player_level_up():
	msg_log_update("플레이어가 레벨업을 했습니다")
	state["upgrade_point"] += 5
	state["skill_point"] += 5
	state["level"] += 1
	state["max_exp"] += int(state["max_exp"] * 1.2)
	state["current_exp"] = 0
	state["current_hp"] = state["max_hp"]
	state["current_mp"] = state["max_mp"]
	update_hud(state["max_hp"], "hp")
	update_hud(state["max_mp"], "mp")
	update_state()
	
func calc_def(damage):
	var def_percent = float(state["def"]) / (float(state["def"]) + DEF_VALUE) * 100.0
	return int(float(damage) * (1.0 - (def_percent / 100.0)))
		
	
func calc_exp(exp_value):
	msg_log_update("경험치를 얻었습니다 : " + str(exp_value))
	while true:
		var temp = (state["max_exp"] - state["current_exp"])
		if exp_value - temp >= 0:
			exp_value -= temp
			player_level_up()
			continue
		else:
			state["current_exp"] += exp_value
			update_hud(state["current_exp"], "exp")
			update_state()
			break
		return

func check_player_coin(coin_value):
	if (state["coin"] - coin_value) >= 0:
		return true 
	else:
		return false
		
# 장착중인 장비를 판매하려는것과 구매하려는 것이 현재 장비 인벤에 존재하는지
func check_already_wear_equipment(new_item_code):
	for equipment in current_equipment:
		if current_equipment[equipment]["item"] == null:
			continue
		else:
			# 현재 착용중인 장비라면 
			var equipment_code = current_equipment[equipment]["item"].get_code()
			if equipment_code == new_item_code:
				return true
				
	return false
	
	
# 장비창에 현재 해당 아이템이 있는지
func check_already_has_equipment(item_code):
	if inventory["equipment"].has(item_code):
		return true
	else:
		return false
	
## SIGNAL
## 장비 무기의 경우 is_echant라는 키가 없으면 is_enchant = false, enchant = null로 설정
func get_item(item:Dictionary):
	# 무기의 경우 이미 가지고 있다면
	var numberof = item["numberof"]
	var type = item["type"]
	var code = item["code"]
		
	var item_name = get_node("/root/Items").Items[code]["item_name"]
	
	if check_already_has_equipment(item["code"]):
		msg_log_update("이미 해당 " + str(item_name) + " 장비를 가지고 있습니다")
		return
	change_inventory_item_number(type, code, numberof, +1)
	#add_message_to_chatbox("아이템을 얻었습니다 : " + str(item_name) + " " + str(numberof) + "개"ㄷ)	
	msg_log_update("아이템을 얻었습니다 : " + str(item_name) + " " + str(numberof) + "개")
	update_inventory()
	
func get_spoil(item):
	get_item(item)
	#spoil.queue_free()
	
func get_current_equipment():
	return current_equipment

func set_current_equipment(type, item_scene):
	if item_scene == null:
		current_equipment[type]["item"] = null
	else:
		current_equipment[type]["item"] = item_scene.instance()

func set_player_node_path(path):
	player_node_path = path

func get_player_node_path():
	return player_node_path

func check_upgrade_point():
	if state["upgrade_point"] <= 0:
		return false
	return true
	
func change_upgrade_point(value):
	state["upgrade_point"] += value

func increase_max_hp():
	var value = 40
	state["max_hp"] += value
	update_hud(state["current_hp"], "hp")
	return true
	
func increase_max_mp():
	var value = 30
	state["max_mp"] += value
	update_hud(state["current_mp"], "mp")
	return true
	
func increase_crit():
	var value = 0.37
	if (state["crit"] + value) > 100:
		return false
	state["crit"] += value
	return true
	
func increase_crit_damage():
	var value = 1
	state["crit_damage"] += value
	return true
	
func increase_def():
	var value = 11
	state["def"] += value
	return true
	
func increase_attack():
	var min_value = 4
	var max_value = 9
	state["min_attack"] += min_value 
	state["max_attack"] += max_value
	return true

# 여기서 mask는 무기를 착용함과 뻄에 있어서 되돌릴 때 쓰는 값이다.
# 장비에 max_hp나 max_ep값을 올려주는 장비를 입었다가 뺄 때current_hp가 더 높으면 안됨
func increase_state_from_effect(effects, mask):
	for effect in effects:
			state[effect] += (effects[effect] * mask)
			check_overflow_state()
			if effect == "current_hp" or effect == "max_hp":
				update_hud(state["current_hp"], "hp")
			elif effect == "current_mp" or effect == "max_mp":
				update_hud(state["current_mp"], "mp")
	update_state()
	
func get_current_hp():
	return state["current_hp"]

func check_overflow_state():
	if state["current_hp"] >= state["max_hp"]:
		state["current_hp"] = state["max_hp"]

	if state["current_mp"] >= state["max_mp"]:
		state["current_mp"] = state["max_mp"]
		
	if state["crit"] >= 100:
		state["crit"] = 100

	if state["min_attack"] > state["max_attack"]:
		state["min_attack"] = state["max_attack"]












