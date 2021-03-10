extends CanvasLayer

signal use_item 

var items = null
var player_variables = null
var current_inven_type = "consumption" #equipment, etc, consumption
onready var slot_grid = $Sprite/ScrollContainer/GridContainer
onready var item_name = $Sprite/DetailContainer/ItemName
onready var item_description = $Sprite/DetailContainer/ItemDescription
onready var item_effect = $Sprite/DetailContainer/ItemEffect

# 인벤토리 클릭시 어떤 것인지 알 수 있도록 아이템코드 등록
# code + type + slot 
var inventory_slot_dict = {}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	items = get_node("/root/Items").Items
	player_variables = get_node("/root/PlayerVariables")
	load_slot_from_inventory()

func make_dynamic_font()->DynamicFont:
	# font 설정
	var dynamic_font = DynamicFont.new()
	dynamic_font.font_data = load("res://assets/fonts/독립기념관체.ttf")
	dynamic_font.size = 20
	return dynamic_font
	
func init_slot():
	for index in inventory_slot_dict:
		inventory_slot_dict[index]["slot"].queue_free()
	inventory_slot_dict = {}

# index는 클릭시 시그널 전송할 때 어떤 것을 눌렀는지 구별하기 위한 파라미터
func make_slot(index:int, code:int)->Panel:
	var player_inventory = get_node("/root/PlayerVariables").inventory
	var slot = Panel.new()
	slot.rect_size.x = 100 
	slot.rect_size.y = 100
	slot.rect_min_size.x = 100
	slot.rect_min_size.y = 100
	# 한번 클릭과 더블클릭 이벤트 처리
	slot.connect("gui_input", self, "_on_Slot_gui_input", [index])
	slot.get_stylebox("panel", "").set_texture(load("res://assets/art/inventory/inventory_slot.png"))
	
	var texture_rect = TextureRect.new()
	texture_rect.expand =true
	texture_rect.texture = load(items[code]["item_image"])
	texture_rect.rect_position.x =14
	texture_rect.rect_position.y = 5
	texture_rect.rect_size.x = 512
	texture_rect.rect_size.y = 512 
	texture_rect.rect_scale.x = 0.13
	texture_rect.rect_scale.y = 0.13
	
	var label = Label.new()
	if current_inven_type != "equipment":
		label.text = str(player_inventory[current_inven_type][code]["numberof"])
	label.set("custom_fonts/font", make_dynamic_font())
	label.rect_position.x = 30
	label.rect_position.y = 80
	label.rect_size.x = 35
	label.rect_size.y = 15
	label.set("custom_colors/font_color",Color(0,0,0))
	
	slot.add_child(texture_rect)
	slot.add_child(label)
	
	return slot
	
func load_slot_from_inventory():
	init_slot()
	var index:int = 0
	var player_inventory = player_variables.inventory
	for player_item_code in player_inventory[current_inven_type]:
		var slot = make_slot(index, player_item_code)
		inventory_slot_dict[index] = {
			"slot" : slot,
			"code" : player_item_code, 
			"type" : current_inven_type,
		}
		slot_grid.add_child(slot)
		index+=1
	
func _on_Slot_gui_input(event: InputEvent, extra_arg_0: int) -> void:
	if event is InputEventMouseButton and event.is_doubleclick():
		_on_use_item(extra_arg_0)
		
	elif event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		show_item_detail(extra_arg_0)
		# 퀵슬롯 등록
		if current_inven_type == "consumption":
			pass
			#_on_open_quick_slot(extra_arg_0)
	
func show_item_detail(index):
	var code = inventory_slot_dict[index]["code"]
	var item = items[code]
	item_name.text = item["item_name"]
	item_description.text = item["item_description"]
	if item["affect_player"] == true:
		item_effect.text = ""
		for effect in item["effect"]:
			item_effect.text += (str(effect) + "->" + str(item["effect"][effect])) 
	else:
		item_effect.text = "효과없음"

func _on_use_item(index):
	var code = inventory_slot_dict[index]["code"]
	var numberof = 1
	emit_signal("use_item", code, numberof)

func _on_change_inven_type(extra_arg_0: String) -> void:
	current_inven_type = extra_arg_0
	load_slot_from_inventory()
