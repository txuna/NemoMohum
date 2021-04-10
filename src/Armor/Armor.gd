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

func minus_armor_state_to_player():
	player_variable.increase_state_from_effect(armor_info["effect"], -1)

func set_armor(code):
	armor_code = code

func get_code():
	return armor_info["code"]
	
func get_type():
	return armor_info["armor_type"]
