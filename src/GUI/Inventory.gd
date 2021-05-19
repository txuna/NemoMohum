extends CanvasLayer

signal use_item 

var items = null
var player_variables = null

var current_inven_type = "consumption" #equipment, etc(soulstone), consumption
var current_index:int

onready var slot_grid = $Sprite/ScrollContainer/GridContainer
onready var item_name = $Sprite/DetailContainer/ItemName
onready var item_description = $Sprite/DetailContainer/ItemDescription
onready var item_effect = $Sprite/DetailContainer/ItemEffect
onready var coin_value = $Sprite/CoinValue
onready var use_button = $Sprite/UseButton
onready var item_enchant = $Sprite/DetailContainer/ItemEnchant
onready var item_quest = $Sprite/DetailContainer/ItemQuest

onready var quick_slots = $Sprite/QuickSlot
# 인벤토리 클릭시 어떤 것인지 알 수 있도록 아이템코드 등록
# code + type + slot 

var inventory_slot_dict = {}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	items = get_node("/root/Items").Items
	player_variables = get_node("/root/PlayerVariables")
	load_slot_from_inventory()

func make_dynamic_font(font_size)->DynamicFont:
	# font 설정
	var dynamic_font = DynamicFont.new()
	dynamic_font.font_data = load("res://assets/fonts/NanumBarunpenR.ttf")
	dynamic_font.size = font_size
	return dynamic_font
	
func init_slot():
	for index in inventory_slot_dict:
		inventory_slot_dict[index]["slot"].queue_free()
	inventory_slot_dict = {}

# index는 클릭시 시그널 전송할 때 어떤 것을 눌렀는지 구별하기 위한 파라미터
func make_slot(index:int, code:int)->Panel:
	var player_inventory = get_node("/root/PlayerVariables").inventory
	var slot = Panel.new()
	slot.rect_size = Vector2(100, 100)
	slot.rect_min_size = Vector2(100, 100)
	# 한번 클릭과 더블클릭 이벤트 처리
	slot.connect("gui_input", self, "_on_Slot_gui_input", [index])
	slot.get_stylebox("panel", "").set_texture(load("res://assets/art/inventory/inventory_slot.png"))
	
	var texture_rect = TextureRect.new()
	texture_rect.expand =true
	texture_rect.texture = items[code]["item_image"]
	texture_rect.rect_position = Vector2(14, 5)
	texture_rect.rect_size = Vector2(512, 512)
	texture_rect.rect_scale = Vector2(0.13, 0.13)
	
	var label = Label.new()
	if current_inven_type != "equipment":
		label.text = str(player_inventory[current_inven_type][code]["numberof"])
	label.set("custom_fonts/font", make_dynamic_font(20))
	label.rect_position = Vector2(30, 80)
	label.rect_size = Vector2(35, 15)
	label.set("custom_colors/font_color",Color(0,0,0))
	
	slot.add_child(texture_rect)
	slot.add_child(label)
	
	return slot
	
func load_coin():
	coin_value.text = str(player_variables.state["coin"])
	
func load_slot_from_inventory():
	load_coin()
	init_slot()
	var index:int = 0
	var player_inventory = player_variables.inventory
	if not player_inventory.has(current_inven_type):
		return
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
			use_button.disabled = false
			current_index = extra_arg_0
			_on_open_quick_slot(extra_arg_0)
	
		elif current_inven_type == "equipment":
			use_button.disabled = false
			current_index = extra_arg_0
		else:
			return
	
func show_item_enchant(code:int, type:String):
	var enchant_list = EnchantList.new() 
	var inventory = player_variables.inventory
	var enchant_table = player_variables.enchant_table
	item_enchant.text = ""
	if inventory[type][code]["is_enchant"] == false:
		item_enchant.text = "인챈트 효과 없음" 
		
	else:
		for option in enchant_table[code]["state_option"]:
			item_enchant.text += enchant_list.state_enchant_list[option]["name"] + "\n"
			
	return
	
func show_item_detail(index):
	if not inventory_slot_dict.has(index):
		return
	var code = inventory_slot_dict[index]["code"]
	var item = items[code]
	var type = item["type"]
	item_name.text = item["item_name"]
	item_description.text = item["item_description"]
	if item["affect_player"] == true:
		item_effect.text = ""
		for effect in item["effect"]:
			item_effect.text += (str(effect) + ":" + str(item["effect"][effect]))  + "\n"
	else:
		item_effect.text = "효과없음"
		
	if item["is_quest_item"]:
		item_quest.text = "퀘스트 아이템"
	else:
		item_quest.text = "일반 아이템"
	
	show_item_enchant(code, type)


func _on_use_item(index):
	if not inventory_slot_dict.has(index):
		return
	var code = inventory_slot_dict[index]["code"]
	var numberof = 1
	emit_signal("use_item", code, numberof)

func _on_change_inven_type(extra_arg_0: String) -> void:
	current_inven_type = extra_arg_0
	use_button.disabled = true
	load_slot_from_inventory()

func init_quick_slot():
	for slot in quick_slots.get_children():
		slot.queue_free()

func make_quick_slot(index:int):
	init_quick_slot()
	for slot_key in player_variables.get_quick_slot():
		if not inventory_slot_dict[index]:
			return
		var code = inventory_slot_dict[index]["code"]
		var button = Button.new()
		button.connect("pressed", self, "_on_set_inventory_quickslot", [slot_key, code])
		button.text = slot_key
		button.set("custom_fonts/font", make_dynamic_font(48))
		quick_slots.add_child(button)
	
	
func _on_open_quick_slot(index:int):
	make_quick_slot(index)

func _on_set_inventory_quickslot(slot_key:String, code:int):
	player_variables.set_quick_slot(slot_key, code, "consumption")

func _on_UseButton_pressed() -> void:
	_on_use_item(current_index)
	

