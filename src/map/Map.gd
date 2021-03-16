extends Node2D

const ROBOT = preload("res://src/Enemy/robot/Robot.tscn")
const TOY_ROBOT = preload("res://src/Enemy/toyrobot/ToyRobot.tscn")

const MAP_CONFIG = "res://config/MapConfig.json"
var player = null

var map_config = {}


onready var EnemySpawnPosition = $EnemySpawnPosition


func _ready() -> void:
	pass
	
	
func load_map_data(map_code:int):
	var map_data = File.new()
	if not map_data.file_exists(MAP_CONFIG):
		return
	map_data.open(MAP_CONFIG, map_data.READ)
	map_config = parse_json(map_data.get_as_text())
	map_config = map_config[str(map_code)]
	map_data.close()
	set_map()
	
func set_map():
	spawn_player()
	spawn_npc()	
	
func spawn_player():
	player = preload("res://src/Player/Player.tscn").instance() 
	var x = map_config["player_spawn_position"]["x"]
	var y = map_config["player_spawn_position"]["y"]
	player.global_position = Vector2(x, y)
	add_child(player)
	
func spawn_npc():
	var npcs = Npcs.new().NpcList
	for npc_data in map_config["npc_spawn_position"]:
		var npc_code = npc_data["npc_code"]
		var npc = load(npcs[int(npc_code)]["scene"]).instance()
		var x = npc_data["spawn_position"]["x"]
		var y = npc_data["spawn_position"]["y"]
		npc.global_position = Vector2(x, y)
		add_child(npc)

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
