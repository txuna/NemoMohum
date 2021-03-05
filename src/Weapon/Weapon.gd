extends Node2D

const LEFT = true
const RIGHT = false

var weapon_info = null
var weapon_code = null
var items = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	items = get_node("/root/Items").Items
	weapon_info = items[weapon_code]
	pass # Replace with function body.

func set_weapon(code):
	weapon_code = code

func get_weapon_code():
	return weapon_info["code"]
	
func get_weapon_type():
	return weapon_info["weapon_type"]
