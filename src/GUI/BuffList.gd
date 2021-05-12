extends CanvasLayer

const BUFF = 1
const COOLDOWN = 2

onready var BuffContainer = $ScrollContainer/HBoxContainer
onready var CooldownContainer = $CooldownContainer/HBoxContainer

func _ready() -> void:
	init_buff_list()


func add_buff_icon(skill_code:int, type:int):
	var texture_rect = make_texture(skill_code)
	if type == BUFF:
		BuffContainer.add_child(texture_rect)
	elif type == COOLDOWN:
		CooldownContainer.add_child(texture_rect)


func init_buff_list():
	for buff in BuffContainer.get_children():
		buff.queue_free()
	
	for skill in CooldownContainer.get_children():
		skill.queue_free()

func remove_buff_icon(skill_code:int, type:int):
	if type == BUFF:
		BuffContainer.get_node(str(skill_code)).queue_free()
	elif type == COOLDOWN:
		CooldownContainer.get_node(str(skill_code)).queue_free()

func _on_buff_switch_notification(switch:bool, skill_code:int, type:int):
	if switch:
		add_buff_icon(skill_code, type)
	else:
		remove_buff_icon(skill_code, type)


func make_texture(skill_code)->TextureRect:
	var texture_rect = TextureRect.new()
	texture_rect.name = str(skill_code)
	texture_rect.texture = get_node("/root/Skills").Skills[skill_code]["image"]
	return texture_rect
