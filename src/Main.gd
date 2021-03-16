extends Node


const Mountain = preload("res://src/map/mountain/Mountain.tscn")
#const QuestManager = preload("res://src/quest/QuestManager.tscn")


func _ready() -> void:
	game_manager()

func game_manager():
	load_map()


func load_map():
	var mountain = Mountain.instance()
	add_child(mountain)
