extends "res://src/Skill/BaseSkill.gd"


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
const SPEED = 1800
var velocity = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	velocity.x = SPEED * delta * skill_direction 
	translate(velocity)


func _on_AliveTimer_timeout() -> void:
	queue_free()
