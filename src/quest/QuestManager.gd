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

func get_all_quest():
	return quest_list.get_all_quest()

# 퀘스트 코드를 기반으로 해당 퀘스트 객체 반환
func get_quest(quest_code):
	return quest_list.QuestList[quest_code]

func give_supplies_to_player(supplies):
	var player_node_path = get_node("/root/PlayerVariables").get_player_node_path()
	var player_node = get_node_or_null(player_node_path)
	if player_node == null:
		print("Error, Player is NULL! So, Can't give supplies to player")
		return 
	player_node.get_quest_reward(supplies, "Supplies")
	

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
		#퀘스트 수락 / 플레이어의 인벤토리 검사 함수 호출, #사전 지급품 제공
		quest["quest_state"] = PROGRESS
		_on_add_quest_in_progress(quest_code)
		check_player_item()
		give_supplies_to_player(quest["quest_supplies"])
		
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
	player_node.get_quest_reward(quest["quest_reward"], "Reward")
	return true

func get_quest_name(quest_code):
	return get_quest(quest_code)["quest_name"]
	
func get_quest_state(quest_code):
	return get_quest(quest_code)["quest_state"]

func get_quest_in_progress():
	return quest_in_progress

func get_quest_before_summary(quest_code):
	return get_quest(quest_code)["quest_before_summary_msg"]

func get_quest_summary(quest_code):
	return get_quest(quest_code)["quest_summary_msg"]


func get_quest_condition(quest_code):
	return get_quest(quest_code)["condition"]

func get_quest_npc_name(quest_code):
	var npc_code = get_quest(quest_code)["npc_code"]
	var npcs = Npcs.new() 
	var npc_name = npcs.NpcList[npc_code]["name"]
	return npc_name
	

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

## 아이템코드를 기반으로 해당 아이템이 현재 진행중인 퀘스트의 요건에 필요한 템인지 체크
func check_item_in_progress_quest(item_code:int):
	for quest_code in quest_in_progress:
		var quest = get_quest(quest_code)
		for quest_goal in quest["quest_goal"]["item"]:
			if quest_goal["code"] == item_code:
				return true #해당 아이템 코드가 플레이어가 진행중인 퀘스트에 포함되는 퀘스트 아이템이라면! 
	return false
	
#시작가능인지 조건미달인치 체크
func check_can_start_quest(quest_code):
	var player_level = get_node("/root/PlayerVariables").get_player_level()
	var quest_condition = get_quest_condition(quest_code)

	# 플레이어 레벨이 미달이라면
	if player_level < quest_condition["level"]:
		return false
		
	# 플레이어가 사전 퀘스트를 달성하지 못했다면
	for pre_quest_code in quest_condition["quest_list"]:
		if get_quest_state(pre_quest_code) != WAS_COMPLETE:
			return false
			
	return true
	 
	
	
	
	
	
	

	
	
