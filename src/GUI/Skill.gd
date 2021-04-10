extends CanvasLayer

var skill_dict = {
	
}

var current_skill_type = "Gun"

var skill_list = null
var player_state = null

signal upgrade_skill

onready var SkillContainer = $skill_background/ScrollContainer/VBoxContainer
onready var skill_point = $skill_background/skill_point
onready var skill_detail = $skill_background/Detail
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	skill_detail.visible = false
	skill_list = get_node("/root/Skills").Skills
	player_state = get_node("/root/PlayerVariables").state
	open_skill()

func init_skill():
	var skills = SkillContainer.get_children()
	for skill in skills:
		skill.queue_free()

func update_skill_point():
	skill_point.text = str(player_state["skill_point"])

func open_skill():
	update_skill()
	update_skill_point()

func _on_upgrade_skill(code:int):
	emit_signal("upgrade_skill", code)
	update_skill()
	update_skill_point()

func update_skill():
	init_skill()
	for skill_code in skill_list:
		if skill_list[skill_code]["type"] != current_skill_type:
			continue
		var container = make_skill_container(skill_code)
		SkillContainer.add_child(container)	
	
func make_skill_container(code)->TextureRect:
	var texture_rect = TextureRect.new()
	texture_rect.connect("gui_input", self, "_on_skill_detail_gui_input", [code])
	texture_rect.texture = load("res://assets/art/skill_gui/skill_slot.png") 
	
	var panel = make_panel(code)
	var skill_name = make_skill_name_label(code)
	var skill_level = make_skill_level_label(code)
	var upgrade_button = make_upgrade_button(code)
	
	texture_rect.add_child(panel)
	texture_rect.add_child(skill_name)
	texture_rect.add_child(skill_level)
	texture_rect.add_child(upgrade_button)
	return texture_rect
	
func make_panel(code)->Panel:
	var panel = Panel.new()
	panel.get_stylebox("panel", "").set_texture(load("res://assets/art/inventory/inventory_slot.png"))
	panel.rect_position = Vector2(15, 15)
	panel.rect_size = Vector2(128, 128)
	panel.rect_min_size = Vector2(128, 128)
	
	var texture_rect = TextureRect.new()
	texture_rect.expand = true
	texture_rect.rect_size = Vector2(128, 128)
	texture_rect.texture = skill_list[code]["image"]
	
	panel.add_child(texture_rect)
	return panel
	
	
func make_label(text:String, 
				position_x:int, position_y:int, 
				size_x:int, size_y:int, 
				font_size:int)->Label:
					
	var label = Label.new()
	label.text = text
	label.rect_position = Vector2(position_x, position_y)
	label.rect_size = Vector2(size_x, size_y)
	label.set("custom_fonts/font", make_dynamic_font(font_size))
	label.set("custom_colors/font_color",Color(0,0,0))
	return label
	
func make_skill_name_label(code)->Label:
	var label = make_label(skill_list[code]["skill_name"], 160, 16, 272, 48, 36)
	return label
	
func make_skill_level_label(code)->HBoxContainer:
	var hbox = HBoxContainer.new()
	hbox.rect_position = Vector2(160, 100)
	hbox.rect_size = Vector2(112, 40)
	
	var skill_lv = make_label("Level", 0, 0, 75, 40, 36)
	var skill_level = make_label(str(skill_list[code]["skill_level"]), 77, 0, 75, 40, 36)
	
	hbox.add_child(skill_lv)
	hbox.add_child(skill_level)
	return hbox
	
	
func make_upgrade_button(code)->Button:
	var button = Button.new()
	button.text = "업그레이드"
	button.set("custom_fonts/font", make_dynamic_font(24))
	button.rect_position = Vector2(315, 100)
	button.rect_size = Vector2(118, 45)
	button.connect("pressed", self, "_on_upgrade_skill", [code])
	return button

func make_dynamic_font(font_size:int)->DynamicFont:
	# font 설정
	var dynamic_font = DynamicFont.new()
	dynamic_font.font_data = load("res://assets/fonts/NanumSquareRoundB.ttf")
	dynamic_font.size = font_size
	return dynamic_font


func _on_change_skill_type(extra_arg_0: String) -> void:
	current_skill_type = extra_arg_0
	update_skill()

# 스킬 상세 설명
func _on_skill_detail_gui_input(event: InputEvent, code:int) -> void:
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		skill_detail.visible = true
		skill_detail.get_node("skill_name").text = skill_list[code]["skill_name"]
		skill_detail.get_node("skill_description").text = skill_list[code]["skill_description"]
