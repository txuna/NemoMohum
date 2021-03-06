extends Node

var current_equipment = {
	"weapon" : {
		"item" : null,
	},
	"shirt" : {
		"item" : null,
	},
	"pants" : {
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
	"min_attack" : 50, 
	"max_attack" : 120, 
	"current_hp" : 1, 
	"max_hp" : 1, 
	"current_mp" : 1,
	"max_mp" : 1,
	"crit" : 1, 
	"crit_damage" : 1, 
	"coin" : 0,
	"level" : 1,
	"current_exp" : 0, 
	"max_exp" : 1,
}

var inventory = {
	"equipment" : {
		0xA000:{
			"code" : 0xA000,
			"numberof" : 1,
		},
		0xA001:{
			"code" : 0xA001,
			"numberof" : 1,
		}
	},
	"consumption" : {
		0xB000:{
			"code" : 0xB000,
			"numberof" : 1,
		},
	},
	"etc" : {
		0xC000:{
			"code" : 0xC000,
			"numberof" : 1,
		},
	},
}

var player_node_path = null

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
				"numberof" : numberof
			}
	update_inventory()
	
func use_item(type, code, numberof, mark, affect_player):
	if affect_player == true:
		# do effect
		pass
	change_inventory_item_number(type, code, numberof, mark)
		
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
		
func get_coin(enemy_coin):
	state["coin"] += enemy_coin
	update_inventory()
	
func get_exp(enemy_exp):
	pass
	
func get_item(item:Dictionary):
	# 무기의 경우 이미 가지고 있다면
	if inventory["equipment"].has(item["code"]):
		return
		
	#var item_name = get_node("/root/Items").Items[item["code"]]["item_name"]
	var numberof = item["numberof"]
	var type = item["type"]
	var code = item["code"]
	change_inventory_item_number(type, code, numberof, +1)
	#add_message_to_chatbox("아이템을 얻었습니다 : " + str(item_name) + " " + str(numberof) + "개")	
	update_inventory()
	
func get_spoil(spoil):
	var item = spoil.get_item()
	get_item(item)
	spoil.queue_free()
	
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


















