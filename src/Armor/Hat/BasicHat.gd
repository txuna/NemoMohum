extends "res://src/Armor/Armor.gd"

# 갑옷정보 셋업
func _init() -> void:
	set_armor(0xA031)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func set_direction(direction):
	rotation_degrees = 0
	if direction == RIGHT:
		scale.x = 1
	else:
		scale.x = -1
