extends Node2D



# Called when the node enters the scene tree for the first time.
onready var Paritlce = $Particles2D
func _ready() -> void:
	Paritlce.emitting = true


func _on_Timer_timeout() -> void:
	queue_free()
