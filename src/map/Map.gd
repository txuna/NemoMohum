extends Node2D

const ROSE = preload("res://src/Enemy/Rose/Rose.tscn")

onready var EnemySpawnPosition = $EnemySpawnPosition
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func spawn_enemy():
	var enemy = ROSE.instance()
	enemy.global_position = EnemySpawnPosition.position
	#rose.connect("EnemyDeath", player, "_on_enemy_death")
	get_tree().call_group("enemies", "connect", enemy)
	add_child(enemy)
