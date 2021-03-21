extends CanvasLayer

onready var QuestListContainer = $TextureRect/QuestScrollContainer/QuestContainer
onready var QuestDetail = $TextureRect/QuestDetail


const NOT_START = 0
const PROGRESS = 1
const CAN_COMPLETE = 2
const WAS_COMPLETE = 3 #이미 완료된거

var quest_manager = null

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
	var quest_code_in_progress = quest_manager.get_quest_in_progress()
	for quest_code in quest_code_in_progress:
		var hbox = make_hbox(quest_code)
		QuestListContainer.add_child(hbox)
	
	
func make_dynamic_font()->DynamicFont:
	# font 설정
	var dynamic_font = DynamicFont.new()
	dynamic_font.font_data = load("res://assets/fonts/독립기념관체.ttf")
	dynamic_font.size = 32
	return dynamic_font	

func make_label(text:String)->Label:
	var label = Label.new()
	label.text = text
	label.set("custom_colors/font_color",Color(0,0,0))
	label.set("custom_fonts/font", make_dynamic_font())
	return label
	
func make_hbox(quest_code:int)->HBoxContainer:
	var hbox = HBoxContainer.new()
	var state = quest_manager.get_quest_state(quest_code)
	var name_text = quest_manager.get_quest_name(quest_code)
	var state_text 
	if state == CAN_COMPLETE:
		state_text = "[완료가능] "
	elif state == PROGRESS:
		state_text = "[진행중] "
	
	var state_label = make_label(state_text)
	var name_label = make_label(name_text)
	hbox.add_child(state_label)
	hbox.add_child(name_label)
	
	hbox.connect("gui_input", self, "show_detail_quest", [quest_code])
	return hbox
	
func show_detail_quest(event:InputEvent, quest_code:int):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		QuestDetail.text = quest_manager.get_quest_summary(quest_code)
	
func give_up_quest():
	pass
