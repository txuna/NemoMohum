extends Node2D

const ROSE = preload("res://src/Enemy/Rose/Rose.tscn")
const ROBOT = preload("res://src/Enemy/robot/Robot.tscn")
const TOY_ROBOT = preload("res://src/Enemy/toyrobot/ToyRobot.tscn")
var player = null

onready var EnemySpawnPosition = $EnemySpawnPosition
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = preload("res://src/Player/Player.tscn").instance() 
	player.global_position = $PlayerSpawnPosition.position
	add_child(player)

func spawn_enemy():
	for i in range(10):
		var enemy = TOY_ROBOT.instance()
		enemy.global_position = EnemySpawnPosition.position
		enemy.connect("EnemyDeath", player, "_on_enemy_death")
		get_tree().call_group("enemies", "connect", enemy)
		add_child(enemy)


func _on_Timer_timeout() -> void:
	var size = get_tree().get_nodes_in_group("enemies").size();
	if  size <= 2:
		spawn_enemy()
