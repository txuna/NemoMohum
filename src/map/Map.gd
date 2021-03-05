extends Node2D

const ROSE = preload("res://src/Enemy/Rose/Rose.tscn")
var player = null

onready var EnemySpawnPosition = $EnemySpawnPosition
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = preload("res://src/Player/Player.tscn").instance() 
	player.global_position = $PlayerSpawnPosition.position
	add_child(player)

func spawn_enemy():
	var enemy = ROSE.instance()
	enemy.global_position = EnemySpawnPosition.position
	enemy.connect("EnemyDeath", player, "_on_enemy_death")
	get_tree().call_group("enemies", "connect", enemy)
	add_child(enemy)
