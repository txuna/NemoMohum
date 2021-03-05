
extends Control


onready var health_bar = $Bar
onready var update_tween = $UpdateTween
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func show_damage(health):
	var current_hp = health_bar.value
	health_bar.value -= health
	update_tween.interpolate_property(health_bar, "value", current_hp, health_bar.value, 0.2, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	update_tween.start()
	yield(update_tween, "tween_all_completed")

func set_health(health):
	health_bar.max_value = health
	health_bar.value = health
