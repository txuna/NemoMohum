extends "res://src/Weapon/Weapon.gd"


# 무기정보 셋업
func _init() -> void:
	set_weapon(0xA001)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func set_direction(direction):
	rotation_degrees = 0
	if direction == RIGHT:
		#rotation_degrees = 50
		scale.x = -1
	else:
		#rotation_degrees = -20
		scale.x = 1
