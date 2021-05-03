extends Node2D

const LEFT = true
const RIGHT = false

var weapon_info = null
var weapon_code = null
var items = null
var player_variable = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	items = get_node("/root/Items").Items
	weapon_info = items[weapon_code]
	player_variable = get_node("/root/PlayerVariables")
	plus_weapon_state_to_player()

func get_attack_delay():
	return weapon_info["attack_delay"]

func plus_weapon_state_to_player():
	player_variable.increase_state_from_effect(weapon_info["effect"], 1)
	if player_variable.inventory["equipment"][weapon_code]["is_enchant"] == true:
		set_enchant_state(1)

func minus_weapon_state_to_player():
	player_variable.increase_state_from_effect(weapon_info["effect"], -1)
	if player_variable.inventory["equipment"][weapon_code]["is_enchant"] == true:
		set_enchant_state(-1)

# 옵션 부가 수치 증가 및 감소
func set_enchant_state(mask):
	var enchant_list = EnchantList.new()
	var state_options = player_variable.enchant_table[weapon_code]["state_option"]
	for option in state_options:
		player_variable.increase_state_from_effect(enchant_list.state_enchant_list[option]["effect"], mask)
	
	
func set_weapon(code):
	weapon_code = code

func get_code():
	return weapon_info["code"]
	
func get_type():
	return weapon_info["weapon_type"]


