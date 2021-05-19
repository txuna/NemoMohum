extends "res://src/map/Agora/Agora.gd"

onready var ToAgora1 = $Portals/ToAgora1
onready var ToAgora3 = $Portals/ToAgora3

var agora1 = 0x8000
var agora3 = 0x8002 

func _ready() -> void:
	set_portal()
	
func set_portal():
	ToAgora1.set_next_map_code(agora1)
	ToAgora3.set_next_map_code(agora3)
