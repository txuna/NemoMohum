extends CanvasLayer


var equipment_code:int=0
var soulston_code:int=0

signal use_item

onready var EquipTexture = $TextureRect/EquipSlot/TextureRect
onready var SoulStonTexture = $TextureRect/StoneSlot/TextureRect
onready var ItemContainer = $item_list
onready var ItemGrid = $item_list/ScrollContainer/GridContainer
onready var SuccessParticle = $TextureRect/SuccessParticle

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
		
	do_enchant()
	emit_signal("use_item", soulston_code, 1)
	init_enchant_ui()
	get_node("/root/PlayerVariables").msg_log_update("장비강화에 성공했습니다.")
	#queue_free()

func init_enchant_ui():
	soulston_code = 0 
	equipment_code = 0 
	EquipTexture.texture = load("res://assets/art/inventory/inventory_slot.png")
	SoulStonTexture.texture = load("res://assets/art/inventory/inventory_slot.png")
		
func do_enchant():
	var enchant_list = EnchantList.new() 
	var rank = enchant_list.get_rank(soulston_code)
	
	#  옵션의 라인 개수를 구함
	var upgrade_percent = enchant_list.get_upgrade_percent(rank)
	var option_line_number = get_option_line(upgrade_percent)	
	
	# option의 line 갯수 만큼 
	var state_code_list = []
	var skill_code_list = [0x2000] #추후에 기능 추가
	
	var option_percent = upgrade_percent["option_percent"]
	for line in option_line_number:
		randomize()
		var percent  = rand_range(0, 100)
		for option in option_percent:
			if percent <= option["cumulative_percent"]:
				state_code_list.append(option["code"])
				break
				
	set_enchant_to_equipment(state_code_list, skill_code_list)
	
	var particle = load("res://src/Effect/HitEffect.tscn").instance()
	particle.position = SuccessParticle.position
	get_node("TextureRect").add_child(particle)

func set_enchant_to_equipment(state_code_list:Array, skill_code_list:Array): 
	var player_enchant_table = get_node("/root/PlayerVariables").enchant_table
	var player_inventory = get_node("/root/PlayerVariables").inventory
	player_inventory["equipment"][equipment_code]["is_enchant"] = true
	player_enchant_table[equipment_code] = {
		"state_option" : state_code_list,
		"skill_option" : skill_code_list,
	}
		
# 한줄일지 두줄일지 결정짓는 함수
func get_option_line(upgrade_percent)->int:
	var option_line:int
	randomize()
	var percent = rand_range(0, 100)
	if percent <= upgrade_percent["plus_option_percent"]:
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
	
	
func check_already_enchant(item_code:int):
	var player_equipment_inventory = get_node("/root/PlayerVariables").inventory["equipment"]
	if player_equipment_inventory[item_code]["is_enchant"] == true:
		get_node("/root/PlayerVariables").msg_log_update("해당 장비는 이미 인챈트가 되어 있습니다.")
		return false
	return true	
	
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
				
			#이미 장비가 인챈트가 되어 있다면
			if not check_already_enchant(item_code):
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




