extends Node


class_name QuestManager

const NOT_START = 0
const PROGRESS = 1
const CAN_COMPLETE = 2
const WAS_COMPLETE = 3 #이미 완료된거

var quest_in_progress = []
var quest_list = null


func _ready() -> void:
	quest_list = QuestList.new()

func _on_add_quest_in_progress(quest_code):
	quest_in_progress.append(quest_code)
	
func _on_remove_quest_in_progress(quest_code):
	quest_in_progress.erase(quest_code)

# 퀘스트의 상태를 완료상태라면 CAN_COMPLETE로 변경
func _on_notification():
	pass

func get_npc_quest(npc_code):
	return quest_list.NpcQuest[npc_code]

func get_quest(quest_code):
	return quest_list.QuestList[quest_code]

# 시작전이면 진행으로 
# CAN_COMPLETE로 되어있다면 WAS_COMPLETE로 
func set_quest_state(quest_code, current_state):
	var quest = get_quest(quest_code)
	if current_state == NOT_START:
		quest["quest_state"] = PROGRESS
		_on_add_quest_in_progress(quest_code)
		
	elif current_state == CAN_COMPLETE:
		quest["quest_state"] = WAS_COMPLETE
		_on_remove_quest_in_progress(quest_code)

func get_quest_name(quest_code):
	return get_quest(quest_code)["quest_name"]
	
func get_quest_state(quest_code):
	return get_quest(quest_code)["quest_state"]

func get_quest_in_progress():
	return quest_in_progress

func get_quest_summary(quest_code):
	return get_quest(quest_code)["quest_summary_msg"]








