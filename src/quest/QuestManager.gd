extends Node

class_name QuestManager

var quest_in_progress = []
var quest_list = null


func _ready() -> void:
	quest_list = QuestList.new()

func _on_add_quest_in_progress():
	pass
	
func _on_remove_quest_in_progress():
	pass

func _on_notification():
	pass

func get_npc_quest(npc_code):
	return quest_list.NpcQuest[npc_code]

func get_quest(quest_code):
	return quest_list.QuestList[quest_code]
