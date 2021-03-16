extends CanvasLayer

const NOT_START = 0
const PROGRESS = 1
const CAN_COMPLETE = 2
const WAS_COMPLETE = 3 #이미 완료된거

var quest_manager = null
var player_state = null

onready var QuestContainer = $TextureRect/QuestScrollContainer/QuestListContainer
onready var BaseMsg = $TextureRect/MsgContainer/BaseMsg
onready var Name = $TextureRect/Name

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	quest_manager = get_node("/root/Main/QuestManager")
	player_state = get_node("/root/PlayerVariables").state

func make_dynamic_font(font_size)->DynamicFont:
	# font 설정
	var dynamic_font = DynamicFont.new()
	dynamic_font.font_data = load("res://assets/fonts/독립기념관체.ttf")
	dynamic_font.size = font_size
	return dynamic_font

func make_label(quest, count:int)->Label:
	var label = Label.new()
	label.set("custom_fonts/font", make_dynamic_font(24))
	label.set("custom_colors/font_color",Color(0,0,0))
	label.text = str(count) + ") " + quest["quest_name"]
	return label

# 진행할 수 있는거 + 진행중인거 + 완료할 수 있는거
# 레벨과 사전퀘스트 달성 여부를 보고 적절 판단 -> WAS_COMPLETE가 아닌거 표시
func load_possible_quest(npc_code:int, base_msg:String, name:String):
	BaseMsg.text = base_msg
	Name.text = name
	var count = 1
	var npc_quest_list = quest_manager.get_npc_quest(npc_code)
	for quest_code in npc_quest_list:
		var quest = quest_manager.get_quest(quest_code)
		if quest["quest_state"] == WAS_COMPLETE:
			continue
			
		if quest["condition"]["level"] > player_state["level"]:
			continue
			
		if not check_requirement_quest(quest):
			continue
				
		## 최종적으로 불러와지는 퀘스트
		var label = make_label(quest, count)
		QuestContainer.add_child(label)
		count+=1

func check_requirement_quest(quest)->bool:
	for requirement_quest_code in quest["condition"]["quest_list"]:
		var requirement_quest = quest_manager.get_quest(requirement_quest_code)
		if requirement_quest["quest_state"] != WAS_COMPLETE:
			return false
	return true


func _on_Exit_pressed() -> void:
	queue_free()
