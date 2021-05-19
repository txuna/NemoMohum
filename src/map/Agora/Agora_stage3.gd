extends "res://src/map/Agora/Agora.gd"

onready var ToAgora2 = $Portals/ToAgora2

var agora2 = 0x8001 

func _ready() -> void:
	set_portal()
	
func set_portal():
	ToAgora2.set_next_map_code(agora2)
