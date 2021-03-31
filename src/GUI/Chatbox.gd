extends CanvasLayer

const NOT_START = 0
const PROGRESS = 1
const CAN_COMPLETE = 2
const WAS_COMPLETE = 3 #이미 완료된거

var quest_manager = null
var player_state = null

var msg_y = null

onready var QuestContainer = $QuestScrollContainer/QuestListContainer
onready var BaseMsg = $TextureRect/MsgContainer/BaseMsg
onready var ButtonContainer = $TextureRect/MsgContainer/HBoxContainer 
onready var Name = $TextureRect/Name
onready var OkButton = $TextureRect/MsgContainer/HBoxContainer/Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	quest_manager = get_node("/root/Main/QuestManager")
	player_state = get_node("/root/PlayerVariables").state
	OkButton.disabled = true

func make_dynamic_font(font_size)->DynamicFont:
	# font 설정
	var dynamic_font = DynamicFont.new()
	dynamic_font.font_data = load("res://assets/fonts/독립기념관체.ttf")
	dynamic_font.size = font_size
	return dynamic_font

func make_label(quest, count:int)->Button:
	var label = Button.new()
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
		label.connect("gui_input", self, "_on_quest_click", [quest_code])
		count+=1
		
func _on_quest_click(event:InputEvent, quest_code:int):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		# 퀘스트 목록 삭제 
		for quest in QuestContainer.get_children():
			quest.queue_free()
		BaseMsg.text = ""
		msg_y = load_quest_msg(quest_code)
		OkButton.disabled = false
		OkButton.connect("pressed", self, "_on_next_msg")
	else:
		return

# 퀘스트 메시지 로드 
# 기본 메시지 일때는 [확인] 버튼
# 다음 메시지가 있을 때는 [다음] 버튼 
# 퀘스트 마지막 메시지라면 [거젏하기], [수락하기] - yield로 다음 메시지 보여주고 버튼 생성하고 다음 버튼 누르면 반복문 안에 있는 yield로 다시 돌아가고
func load_quest_msg(quest_code):
	var quest:Dictionary = quest_manager.get_quest(quest_code)
	var quest_state:int = quest["quest_state"]
	var type:String
	#var msg:String

	if quest_state == NOT_START:
		type = "quest_not_started_msg"
		
	elif quest_state == PROGRESS:
		type = "quest_progress_msg"
		
	elif quest_state == CAN_COMPLETE:
		type = "quest_complete_msg"
		
	for msg in quest[type]:
		BaseMsg.text = msg
		yield()
	
	# 끝났을 떄 Quest_manager에서 해당 퀘스트가 시작전이라면 진행중으로, CAN_COMPLETE로 되어 있다면 완료로 설정 후 보상 받음
	#quest_state은 현재 퀘스트 상태 
	quest_manager.set_quest_state(quest_code, quest_state)	
	var player_variables = get_node("/root/PlayerVariables")
	player_variables.update_questbox()
	queue_free()
		
func _on_next_msg():
	if msg_y is GDScriptFunctionState && msg_y.is_valid():
		msg_y = msg_y.resume()

# 선행 퀘 및 조건 체크
func check_requirement_quest(quest)->bool:
	for requirement_quest_code in quest["condition"]["quest_list"]:
		var requirement_quest = quest_manager.get_quest(requirement_quest_code)
		if requirement_quest["quest_state"] != WAS_COMPLETE:
			return false
	return true


func _on_Exit_pressed() -> void:
	queue_free()

