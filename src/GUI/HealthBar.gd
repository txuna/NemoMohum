
extends Control


onready var health_bar = $Bar
onready var update_tween = $UpdateTween
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# health is enemy current health
func show_damage(health):
	var current_value = health_bar.value 
	update_tween.interpolate_property(health_bar, "value", current_value, health, 0.4, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	update_tween.start()
	yield(update_tween, "tween_all_completed")

func set_health(health):
	health_bar.max_value = health
	health_bar.value = health
