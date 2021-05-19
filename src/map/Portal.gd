extends Area2D

signal change_map

var next_map_code

func _on_Portal_body_entered(body: Node) -> void:
	emit_signal("change_map", body.get_parent().get_name(), next_map_code)

func set_next_map_code(map_code:int):
	next_map_code = map_code
