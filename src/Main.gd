extends Node


const Title = preload("res://src/GUI/Title.tscn")
const QuestManager = preload("res://src/quest/QuestManager.tscn")
const Hud = preload("res://src/GUI/HUD.tscn")
const MobileTouch = preload("res://src/GUI/MobileTouch.tscn")
const MsgLog = preload("res://src/GUI/MsgLog.tscn")

var map_list = {
	0x8000 : {
		"scene" : preload("res://src/map/mountain/Mountain.tscn"),
		"map_name" : "Mountain",
	},
	0x8001 : {
		"scene" : preload("res://src/map/Jungle/Jungle.tscn"),
		"map_name" : "Jungle",
	}
}

var current_map_code = 0x8000

func _ready() -> void:
	game_manager()

func game_manager():
	load_title()


func _on_game_start():
	get_node("/root/Main/Title").queue_free()
	var mobile_touch = MobileTouch.instance()
	var quest_manager = QuestManager.instance()
	var msg_log = MsgLog.instance()
	var hud = Hud.instance()
	
	call_deferred("add_child", msg_log)
	call_deferred("add_child", mobile_touch)
	call_deferred("add_child", quest_manager)
	call_deferred("add_child", hud)
	load_map()

func load_title():
	var title = Title.instance()
	title.connect("game_start", self, "_on_game_start")
	add_child(title)

func change_map(map_node_name, map_code):
	var previouse_map_instance = get_node_or_null(map_node_name)
	if previouse_map_instance == null:
		return 
		
	previouse_map_instance.queue_free()
	current_map_code = map_code
	load_map()

func load_map():
	var map_instance = map_list[current_map_code]["scene"].instance()
	map_instance.connect("change_map", self, "change_map")
	call_deferred("add_child", map_instance)
