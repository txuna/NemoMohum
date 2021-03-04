extends "res://src/Weapon/Weapon.gd"


# 무기정보 셋업
func _init() -> void:
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func set_direction(direction):
	rotation_degrees = direction
