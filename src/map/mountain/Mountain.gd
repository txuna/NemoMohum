extends "res://src/map/Map.gd"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_map_data(0x8000)
	spawn_enemy()
