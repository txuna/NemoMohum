extends "res://src/Enemy/EnemySkill/EnemySkill.gd"

var velocity:Vector2 = Vector2.ZERO
const SPEED = 500
const GRAVITY = 9.8 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	velocity.x = (SPEED * skill_direction * delta)
	position += velocity

func get_position():
	velocity.x += SPEED * cos(60)
	velocity.y += SPEED * sin(60) - (1/2)

func _on_AliveTimer_timeout() -> void:
	queue_free()
