extends Node


const Mountain = preload("res://src/map/mountain/Mountain.tscn")
const Title = preload("res://src/GUI/Title.tscn")
const QuestManager = preload("res://src/quest/QuestManager.tscn")
const Hud = preload("res://src/GUI/HUD.tscn")

func _ready() -> void:
	game_manager()

func game_manager():
	load_title()
	#load_map()

func _on_game_start():
	get_node("/root/Main/Title").queue_free()
	var quest_manager = QuestManager.instance()
	var hud = Hud.instance()
	
	call_deferred("add_child", quest_manager)
	call_deferred("add_child", hud)
	
	load_map()

func load_title():
	var title = Title.instance()
	title.connect("game_start", self, "_on_game_start")
	add_child(title)

func load_map():
	var mountain = Mountain.instance()
	call_deferred("add_child", mountain)
