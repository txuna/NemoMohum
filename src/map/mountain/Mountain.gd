extends "res://src/map/Map.gd"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_map()
	#load_map_data(0x8000)
	set_enemy_signal()
	#spawn_enemy()
