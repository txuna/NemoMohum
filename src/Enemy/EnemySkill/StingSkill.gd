extends "res://src/Enemy/EnemySkill/EnemySkill.gd"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	queue_free()
