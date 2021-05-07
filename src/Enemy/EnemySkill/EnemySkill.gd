extends Area2D

const RIGHT = false
const LEFT = true

var skill_direction:bool
var damage:int
onready var sprite = $Sprite
onready var sprite_player = $AnimationPlayer
signal EnemyAttack

func _ready() -> void:
	sprite.flip_h = skill_direction
	sprite_player.play("shot")

func init(dam:int, direction:bool) -> void:
	damage = dam 
	skill_direction = direction


func _on_EnemySkill_body_entered(body: Node) -> void:
	emit_signal("EnemyAttack", damage)
	queue_free()
