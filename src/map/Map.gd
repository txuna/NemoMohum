extends Node2D

var player = null

#signal change_map

onready var EnemySpawnPosition = $EnemySpawnPosition
onready var PlayerSpawnPosition = $PlayerSpawnPosition
onready var Portals = $Portals

func _ready() -> void:
	pass

func portal_connect_signal():
	for portal in Portals.get_children():
		portal.connect("change_map", get_node("/root/Main"), "change_map") 

func set_map():
	portal_connect_signal()
	spawn_player()
	
func spawn_player():
	player = preload("res://src/Player/Player.tscn").instance() 
	player.connect("NOTIFY", get_node("/root/Main/QuestManager"), "_on_notification")
	player.connect("BUFF_SWITCH", get_node("/root/Main/BuffList"), "_on_buff_switch_notification")
	get_node("/root/Main/MobileTouch").connect("Action", player, "_on_player_action")
	player.global_position = PlayerSpawnPosition.position
	add_child(player)

func set_enemy_signal():
	var enemies = $Enemies.get_children()
	for enemy in enemies:
		player.connect("PlayerDeath", enemy, "_on_player_death")
		enemy.connect("EnemyDeath", player, "_on_enemy_death")
		enemy.connect("EnemyAttack", player, "_on_take_damage_from_enemy")
		get_tree().call_group("enemies", "connect", enemy)
		
