extends CanvasLayer


var equipment_code:int=0
var soulston_code:int=0

onready var EquipTexture = $TextureRect/EquipSlot/TextureRect
onready var SoulStonTexture = $TextureRect/StoneSlot/TextureRect
onready var ItemContainer = $item_list
onready var ItemGrid = $item_list/ScrollContainer/GridContainer


func _ready() -> void:
	ItemContainer.visible = false

func _on_Exit_pressed() -> void:
	queue_free()


#장비 강화를 한다. EquipSlot과 StoneSlot이 모두 채워져야 함
func _on_upgrade_button_pressed() -> void:
	var items = get_node("/root/Items").Items
	if not items.has(equipment_code) or not items.has(soulston_code):
		get_node("/root/PlayerVariables").msg_log_update("장비 또는 영원석을 선택해주세요. ")
		return 
	var equip_slot_type = items[equipment_code]["type"]
	if equip_slot_type != "equipment":
		get_node("/root/PlayerVariables").msg_log_update("장비를 선택해주세요.")
		return

	var soulstone_type = items[soulston_code]["detail_type"]
	if soulstone_type != "soulstone":
		get_node("/root/PlayerVariables").msg_log_update("영원석을 선택해주세요.")
		return
		
	var option_line_number = get_option_line()	
	# option의 line 갯수 만큼 
	for line in option_line_number:
		pass
		
		
# 한줄일지 두줄일지 결정짓는 함수
func get_option_line()->int:
	var option_line:int
	var enchant_list = EnchantList.new() 
	var rank = enchant_list.get_rank(soulston_code)
	var rank_percent = enchant_list.get_upgrade_percent(rank)
	
	randomize()
	var percent = rand_range(0, 100)
	if percent <= rank_percent["plus_option_percent"]:
		option_line = 2
	else:
		option_line = 1
	
	return option_line


# 장비를 가지고 오는 버튼 누를 시 옆에 목록 생성 
# 장착중인 장비인지 확인
func _on_GetEquip_pressed() -> void:
	load_item_list("equipment")


# 영원석을 가지고 오는 버튼 누를 시 옆에 목록 생성
func _on_GetStone_pressed() -> void:
	load_item_list("etc")


func init_item_container():
	for slot in ItemGrid.get_children():
		slot.queue_free()

func load_item_list(type:String):
	init_item_container()
	ItemContainer.visible = true
	var player_inventory = get_node("/root/PlayerVariables").inventory
	var items = get_node("/root/Items").Items
	for item_code in player_inventory[type]:
		if items[item_code]["detail_type"] in ["armor", "weapon", "soulstone"]:
			var panel = make_panel(item_code)
			ItemGrid.add_child(panel)

func make_panel(item_code:int)->Panel:
	var slot = Panel.new() 
	slot.rect_size = Vector2(64, 64)
	slot.rect_min_size = Vector2(64, 64)
	
	slot.connect("gui_input", self, "_on_Slot_gui_input", [item_code])
	slot.get_stylebox("panel", "").set_texture(load("res://assets/art/inventory/inventory_slot.png"))
	
	var texture_rect = make_texture(item_code)
	slot.add_child(texture_rect)
	
	return slot

func make_texture(item_code)->TextureRect:
	var texture_rect = TextureRect.new()
	texture_rect.expand = true 
	texture_rect.rect_position = Vector2(2,2)
	texture_rect.rect_size = Vector2(60, 60)
	texture_rect.texture = get_node("/root/Items").Items[item_code]["item_image"]
	return texture_rect
	
	
func check_already_equip(detail_type, item_code):
	var items = get_node("/root/Items").Items
	var player_equipment_state = get_node("/root/PlayerVariables").current_equipment
	if detail_type == "weapon":
		if player_equipment_state["weapon"]["item"] != null:
			var current_weapon_code = player_equipment_state["weapon"]["item"].get_code()
			if current_weapon_code == item_code:
				get_node("/root/PlayerVariables").msg_log_update("해당 장비는 장착중이므로 강화가 불가능합니다.")
				return false	
	else:
		var armor_type = items[item_code]["armor_type"]
		if player_equipment_state[armor_type]["item"] != null:
			var current_armor_code = player_equipment_state[armor_type]["item"].get_code()
			if current_armor_code == item_code:
				get_node("/root/PlayerVariables").msg_log_update("해당 장비는 장착중이므로 강화가 불가능합니다.")
				return false
				
	return true

func _on_Slot_gui_input(event:InputEvent, item_code:int):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		var items = get_node("/root/Items").Items
		var detail_type = items[item_code]["detail_type"] 
		var player_equipment_state = get_node("/root/PlayerVariables").current_equipment
		# 해당 장비가 장착중인 장비인지 체크 한다. 만약 착용중인 장비라면 강화가 불가능하다. 
	
		if detail_type in ["weapon", "armor"]:
			if not check_already_equip(detail_type, item_code):
				return
						
			EquipTexture.texture = items[item_code]["item_image"]
			equipment_code = item_code
			
		elif detail_type in ["soulstone"]:
			SoulStonTexture.texture = items[item_code]["item_image"]
			soulston_code = item_code
		else:
			get_node("/root/PlayerVariables").msg_log_update("영원석 또는 장비만을 선택할 수 있습니다.")
			return
			
		ItemContainer.visible = false
		return




