extends Area2D

const RIGHT = 1
const LEFT = -1

var skill_direction:int
var damage:int
onready var sprite = $Sprite
onready var sprite_player = $AnimationPlayer
signal EnemyAttack

func _ready() -> void:
	if skill_direction == RIGHT:
		sprite.flip_h = false
	else:
		sprite.flip_h = true
		
	sprite_player.play("shot")

func init(dam:int, direction:int) -> void:
	damage = dam 
	skill_direction = direction


func _on_EnemySkill_body_entered(body: Node) -> void:
	emit_signal("EnemyAttack", damage)
	queue_free()
