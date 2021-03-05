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
		
		
func get_coin(enemy_coin):
	state["coin"] += enemy_coin
	
func get_exp(enemy_exp):
	pass
	
func get_item(item:Dictionary):
	# 무기의 경우 이미 가지고 있다면
	if inventory["equipment"].has(item["code"]):
		return
	# 소지템 한도 체크
	#if inventory[item["type"]].size() > MAX_PLAYER_ITEM_NUMBEROF:
	#	return
		
	#var item_name = get_node("/root/Items").Items[item["code"]]["item_name"]
	var numberof = item["numberof"]
	if inventory[item["type"]].has(item["code"]) == false:
		inventory[item["type"]][item["code"]] = item
	else:
		inventory[item["type"]][item["code"]]["numberof"] += numberof
	#add_message_to_chatbox("아이템을 얻었습니다 : " + str(item_name) + " " + str(numberof) + "개")	
	
func get_spoil(spoil):
	var item = spoil.get_item()
	get_item(item)
	spoil.queue_free()
	
func get_current_equipment():
	return current_equipment

func set_current_equipment(type, item_scene):
	current_equipment[type]["item"] = item_scene.instance()

func set_player_node_path(path):
	player_node_path = path

func get_player_node_path():
	return player_node_path


















