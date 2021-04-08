extends Node


class_name QuestManager

const NOT_START = 0
const PROGRESS = 1
const CAN_COMPLETE = 2
const WAS_COMPLETE = 3 #이미 완료된거

const NPC = 1
const ENEMY = 2
const ITEM = 3

var quest_in_progress = [] #quest_code list
var quest_list = null


func _ready() -> void:
	quest_list = QuestList.new()

func _on_add_quest_in_progress(quest_code):
	quest_in_progress.append(quest_code)
	
func _on_remove_quest_in_progress(quest_code):
	quest_in_progress.erase(quest_code)


# 완료가능 상태인지 체크한다. 
func check_quest(quest_code):
	var quest = get_quest(quest_code)
	for goal_key in quest["quest_goal"]:
		var goals = quest["quest_goal"][goal_key]
		for goal in goals:
			if goal["player_count"] < goal["numberof"]:
				#퀘스트 미달
				quest["quest_state"] = PROGRESS
				return 
				
	quest["quest_state"] = CAN_COMPLETE

# 퀘스트의 상태를 완료상태라면 CAN_COMPLETE로 변경
# code :  NPC의 코드 몬스터의 코드 아이템의 코드가 될 수 있다. 
# type : NPC, ENENY, ITEM 3가지로 나눠진다. 
# numberof : 수량
func _on_notification(type:int, code:int, numberof:int=0):
	var type_str:String
	if type == NPC:
		type_str = "talk_to"
		
	elif type == ENEMY:
		type_str = "enemy"
		
	elif type == ITEM:
		type_str = "item"

	for quest_code in quest_in_progress:
		var quest_goals = get_quest(quest_code)["quest_goal"][type_str]
		for goal in quest_goals:
			if goal["code"] == code:
				goal["player_count"] += numberof
				check_quest(quest_code)
				# CAN_COMPLETE인지 확인		
	
# NPC code를 기반으로 해당 NPC가 어떠한 퀘스트들을 가지지는지를 반환
func get_npc_quest(npc_code):
	return quest_list.NpcQuest[npc_code]

# 퀘스트 코드를 기반으로 해당 퀘스트 객체 반환
func get_quest(quest_code):
	return quest_list.QuestList[quest_code]

func check_player_item():
	var player_node_path = get_node("/root/PlayerVariables").get_player_node_path()
	var player_node = get_node_or_null(player_node_path)
	if player_node == null:
		return false
	player_node.send_signal_abount_inventory_item()
	
# 시작전이면 진행으로 
# CAN_COMPLETE로 되어있다면 WAS_COMPLETE로 
func set_quest_state(quest_code, current_state):
	var quest = get_quest(quest_code)
	if current_state == NOT_START:
		#퀘스트 수락 / 플레이어의 인벤토리 검사 함수 호출
		quest["quest_state"] = PROGRESS
		_on_add_quest_in_progress(quest_code)
		check_player_item()
		
	elif current_state == CAN_COMPLETE:
		var is_player = give_reward_to_player(quest_code)
		if not is_player:
			return
		quest["quest_state"] = WAS_COMPLETE
		_on_remove_quest_in_progress(quest_code)
		
# 플에이어에게 보상을 제공하고 플레이어의 퀘스트 아이템을 가져간다. 
func give_reward_to_player(quest_code)->bool:
	var quest = get_quest(quest_code)
	var player_node_path = get_node("/root/PlayerVariables").get_player_node_path()
	var player_node = get_node_or_null(player_node_path)
	if player_node == null:
		return false
	player_node.give_item_to_quest(quest["quest_goal"]["item"])
	player_node.get_quest_reward(quest["quest_reward"])
	return true

func get_quest_name(quest_code):
	return get_quest(quest_code)["quest_name"]
	
func get_quest_state(quest_code):
	return get_quest(quest_code)["quest_state"]

func get_quest_in_progress():
	return quest_in_progress

func get_quest_summary(quest_code):
	return get_quest(quest_code)["quest_summary_msg"]


# 현재 진행상태를 확인
func get_quest_progress(quest_code)->Array:
	var quest_goals = get_quest(quest_code)["quest_goal"]
	var status = [
		
	]
	for quest_goal_key in quest_goals:
		for goal in quest_goals[quest_goal_key]:
			var dict = {
				"player_count" : goal["player_count"],
				"goal_count" : goal["numberof"],
				"code" : goal["code"],
			}
			status.append(dict)
	return status






