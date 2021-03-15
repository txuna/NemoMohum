extends Node


const Mountain = preload("res://src/map/mountain/Mountain.tscn")

func _ready() -> void:
	game_manager()

func game_manager():
	load_map()
	#var quest_list = QuestList.new()


func load_map():
	var mountain = Mountain.instance()
	add_child(mountain)
