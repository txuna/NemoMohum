extends CanvasLayer


var equipment_code:int=0
var soulston_code:int=0

func _on_Exit_pressed() -> void:
	queue_free()


#장비 강화를 한다. EquipSlot과 StoneSlot이 모두 채워져야 함
func _on_upgrade_button_pressed() -> void:
	var items = get_node("/root/Items").Items
	if not items.has(equipment_code) or not items.has(soulston_code):
		return 
	var equip_slot_type = items[equipment_code]["type"]
	if equip_slot_type != "equipment":
		return

	var soulstone_type = items[soulston_code]["detail_type"]
	if soulstone_type != "soulstone":
		return
		
	var option_line_number = get_option_line()	
		
		
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
