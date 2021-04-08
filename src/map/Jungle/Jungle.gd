extends "res://src/map/Map.gd"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_map()
	#set_enemy_signal()


func _on_Area2D_body_entered(body: Node) -> void:
	if body.name == "Player":
		emit_signal("change_map", body.get_parent().get_name(), 0x8000)
