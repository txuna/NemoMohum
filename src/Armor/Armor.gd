extends Node2D

const LEFT = true
const RIGHT = false

var armor_info = null
var armor_code = null
var items = null
var player_variable = null


func _ready() -> void:
	items = get_node("/root/Items").Items
	armor_info = items[armor_code]
	player_variable = get_node("/root/PlayerVariables")
	plus_armor_state_to_player()
	
func plus_armor_state_to_player():
	player_variable.increase_state_from_effect(armor_info["effect"], 1)
	if player_variable.inventory["equipment"][armor_code]["is_enchant"] == true:
		set_enchant_state(1)

func minus_armor_state_to_player():
	player_variable.increase_state_from_effect(armor_info["effect"], -1)
	if player_variable.inventory["equipment"][armor_code]["is_enchant"] == true:
		set_enchant_state(-1)

# 옵션 부가 수치 증가 및 감소
func set_enchant_state(mask):
	var enchant_list = EnchantList.new()
	var state_options = player_variable.enchant_table[armor_code]["state_option"]
	for option in state_options:
		player_variable.increase_state_from_effect(enchant_list.state_enchant_list[option]["effect"], mask)

func set_armor(code):
	armor_code = code

func get_code():
	return armor_info["code"]
	
func get_type():
	return armor_info["armor_type"]
