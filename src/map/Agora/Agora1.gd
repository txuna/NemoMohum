extends "res://src/map/Map.gd"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_map()
	set_enemy_signal()
