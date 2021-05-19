extends CanvasLayer

onready var QuestListContainer = $TextureRect/QuestScrollContainer/QuestContainer
onready var QuestDetail = $TextureRect/QuestDetail
onready var ProgessContainer = $TextureRect/ProgressContainer
onready var Quester = $TextureRect/Quester # Npc, 레벨, 사전 퀘스트

const NOT_START = 0 # 시작가능과 조건미달 구별하기
const PROGRESS = 1
const CAN_COMPLETE = 2
const WAS_COMPLETE = 3 #이미 완료된거

var quest_manager = null
var current_quest_code

# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	quest_manager = get_node("/root/Main/QuestManager")
	
	open_quest_list()
	

func _on_Exit_Button_pressed() -> void:
	queue_free()

func init_quest_list():
	for quest in QuestListContainer.get_children():
		quest.queue_free()

func open_quest_list():
	load_quest_list()
	

func load_quest_list():
	init_quest_list()
	var all_quest_list = quest_manager.get_all_quest()
	#var quest_code_in_progress = quest_manager.get_quest_in_progress()
	for quest_code in all_quest_list:
		var hbox = make_hbox(quest_code)
		QuestListContainer.add_child(hbox)
	
func make_dynamic_font()->DynamicFont:
	# font 설정
	var dynamic_font = DynamicFont.new()
	dynamic_font.font_data = load("res://assets/fonts/NanumBarunpenR.ttf")
	dynamic_font.size = 32
	return dynamic_font	

func make_label(text:String)->Label:
	var label = Label.new()
	label.text = text
	label.set("custom_colors/font_color",Color(0,0,0))
	label.set("custom_fonts/font", make_dynamic_font())
	label.rect_size.y = 45
	return label
	
func make_hbox(quest_code:int)->HBoxContainer:
	var hbox = HBoxContainer.new()
	var state = quest_manager.get_quest_state(quest_code)
	var name_text = quest_manager.get_quest_name(quest_code)
	var state_text 
	if state == CAN_COMPLETE:
		state_text = "[완료가능] "
	elif state == PROGRESS: #진행중일때만 진행사항 띄우기
		state_text = "[진행중] "
	elif state == WAS_COMPLETE:
		state_text = "[완료]"
	elif state == NOT_START: # 시작 가능인지, 조건미달인지 체크
		state_text = "[시작 가능]"
	
	var state_label = make_label(state_text)
	var name_label = make_label(name_text)
	hbox.add_child(state_label)
	hbox.add_child(name_label)
	
	hbox.connect("gui_input", self, "show_detail_quest", [quest_code])
	return hbox
	
	
# 시작가능인지 시작 불가능인지 체크하기
func check_can_start():
	pass

#NPc가 누구인지, 레벨은 몇인지, 사전 퀘스트는 무엇인지
func show_quester(quest_code:int):
	var npc_name = quest_manager.get_quest_npc_name(quest_code)
	var quest_condition = quest_manager.get_quest_condition(quest_code)
	var quest_level = quest_condition["level"]
	var quest_name
	if quest_condition["quest_list"].size() == 0:
		quest_name = "사전퀘스트 없음"
	else:
		quest_name = quest_manager.get_quest_name(quest_condition["quest_list"][0]) + " 진행필요"
	Quester.text =  "NPC : " + npc_name + "\n[사전조건]" + "Lv." + str(quest_level)  + " " + quest_name
	
	
	
func show_detail_quest(event:InputEvent, quest_code:int):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		current_quest_code = quest_code
		if quest_manager.get_quest_state(quest_code) == NOT_START:
			QuestDetail.text = quest_manager.get_quest_before_summary(quest_code)
		else:	
			QuestDetail.text = quest_manager.get_quest_summary(quest_code)
		update_progress_state(quest_code)
		show_quester(quest_code)
	
func update_progress_state(quest_code):
	init_progess_container()
		# 진행 상태 표시
		
	#진행중이 아니라면
	if quest_manager.get_quest_state(quest_code) != PROGRESS:
		return
		
	var status = quest_manager.get_quest_progress(quest_code)
	for element in status:
		var progress_text = ""
		if element["code"] >= 0xF000 and element["code"] <= 0xFFFF:
			var name = EnemyState.new().EnemyList[element["code"]]["enemy_name"]
			progress_text += name + " => "
				
		elif element["code"] >= 0xA000 and element["code"] <= 0xCFFF:
			var name = get_node("/root/Items").Items[element["code"]]["item_name"]
			progress_text += name + " => "
				
		progress_text += "[" + str(element["player_count"]) + " / "
		progress_text += str(element["goal_count"]) + "]"
		var label = make_label(progress_text)
		ProgessContainer.get_node("Container").add_child(label)
	ProgessContainer.visible = true	
	
	
func init_progess_container():
	for child in ProgessContainer.get_node("Container").get_children():
		child.queue_free()
	
func give_up_quest():
	pass








