extends CanvasLayer


onready var ExitButton = $shop_background/Exit
onready var BuyContainer = $shop_background/BuyScrollContainer/VBoxContainer
onready var SellContainer = $shop_background/SellScrollContainer/VBoxContainer
onready var coin_value = $shop_background/CoinContainer/CoinValue

onready var NpcImage = $shop_background/NpcImage
onready var PlayerImage = $shop_background/PlayerImage
onready var ItemDetailContainer = $shop_background/ItemDetailContainer


var item_sell_dict = {
	
}

var item_buy_dict = {
	
}

var player_inventory = null
var items = null
var npc_items = null
var current_inven_type = "equipment"
var player_state = null

signal sell_item
signal buy_item

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	items = get_node("/root/Items").Items
	player_inventory = get_node("/root/PlayerVariables").inventory
	player_state = get_node("/root/PlayerVariables").state


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

func set_character_image(npc_code):
	NpcImage.texture =  load(get_node("/root/Npcs").Npcs[npc_code]["image"])
	PlayerImage.texture = load(player_state["image"])

func make_dynamic_font(font_size)->DynamicFont:
	# font 설정
	var dynamic_font = DynamicFont.new()
	dynamic_font.font_data = load("res://assets/fonts/독립기념관체.ttf")
	dynamic_font.size = font_size
	return dynamic_font
	
	
func make_panel(code)->Panel:
	var panel = Panel.new()
	panel.rect_position = Vector2(15, 15)
	panel.rect_size = Vector2(130, 130)
	panel.rect_min_size = Vector2(130, 130)
	panel.get_stylebox("panel", "").set_texture(load("res://assets/art/inventory/inventory_slot.png"))
	
	var texture_rect = TextureRect.new() 
	texture_rect.expand = true 
	texture_rect.texture = load(items[code]["item_image"])
	texture_rect.rect_position = Vector2(0, 0)
	texture_rect.rect_size = Vector2(512, 512)
	texture_rect.rect_scale = Vector2(0.25, 0.25)
	panel.add_child(texture_rect)
	return panel
	
	
func make_name_label(code)->Label:
	var name_label = make_label(items[code]["item_name"], 160, 18, 270, 45, 36)
	return name_label
	
	
# type : sell, buy
func make_price_label(type, code)->Label:
	var coin_label = make_label(str(items[code][type]) + " Coin", 160, 96, 125, 45, 36)
	return coin_label
	
func make_numberof_label(code)->Label:
	var item_type = items[code]["type"]
	var numberof_label = make_label("(" + str(player_inventory[item_type][code]["numberof"]) + ")", 
									0, 0, 0, 0, 36)
	return numberof_label		
	
	
func make_button(index, type)->Button:
	var button = Button.new()
	
	if type == "buy":
		button.connect("pressed", self, "_on_buy_item", [index])
		button.text = "구매"
		button.rect_position = Vector2(335, 97)
		button.rect_size = Vector2(96, 46)
	elif type == "sell":
		button.connect("pressed", self, "_on_sell_item", [index])
		button.text = "판매"
		button.rect_position = Vector2(368, 97)
		button.rect_size = Vector2(64, 46)
		
	button.set("custom_fonts/font", make_dynamic_font(32))
	return button
	
func make_buy_container(index, code)->TextureRect:
	var texture_rect = TextureRect.new()
	texture_rect.connect("mouse_entered", self, "show_detail", [index, "buy"])
	texture_rect.connect("mouse_exited", self, "close_detail")
	
	texture_rect.texture = load("res://assets/art/shop/shop_slot2.png")
	texture_rect.add_child(make_panel(code))
	texture_rect.add_child(make_name_label(code))
	texture_rect.add_child(make_price_label("buy", code))
	texture_rect.add_child(make_button(index, "buy"))
	return texture_rect
	
	
func make_sell_container(index, code)->TextureRect:
	var texture_rect = TextureRect.new()
	texture_rect.texture = load("res://assets/art/shop/shop_slot2.png")
	texture_rect.connect("mouse_entered", self, "show_detail", [index, "sell"])
	texture_rect.connect("mouse_exited", self, "close_detail")
	
	texture_rect.add_child(make_panel(code))
	texture_rect.add_child(make_name_label(code))
	
	var hbox = HBoxContainer.new() 
	hbox.rect_position = Vector2(160, 96)
	hbox.add_child(make_numberof_label(code))
	hbox.add_child(make_price_label("sell", code))
	texture_rect.add_child(hbox)
	texture_rect.add_child(make_button(index, "sell"))
	return texture_rect
	
	
func init_buy_container():
	item_buy_dict = {}
	var containers = BuyContainer.get_children()
	for container in containers:
		container.queue_free()
	
func init_sell_container():
	item_sell_dict = {}
	var containers = SellContainer.get_children()
	for container in containers:
		container.queue_free()
	

func show_sell_interface():
	init_sell_container()
	var index:int = 0
	for player_item_code in player_inventory[current_inven_type]:
		item_sell_dict[index] = {
			"code" : player_item_code
		}
		var sell_container = make_sell_container(index, player_item_code)
		SellContainer.add_child(sell_container)
		index+=1
	
func show_buy_interface():
	init_buy_container()
	var index:int = 0 
	for npc_item_code in npc_items:
		item_buy_dict[index] = {
			"code" : npc_item_code["code"]
		}
		var buy_container = make_buy_container(index, npc_item_code["code"])
		BuyContainer.add_child(buy_container)
		index+=1

func update_coin():
	coin_value.text = str(player_state["coin"])

# 처음 상점을 열때 
func open_shop(npc_code:int):
	npc_items = get_node("/root/Npcs").ShopKeepers[npc_code]
	set_character_image(npc_code)
	show_buy_interface()
	show_sell_interface()
	update_coin()
	
# 해당 상점의 내용물을 Update할 때
func update_shop():
	show_buy_interface()
	show_sell_interface()
	update_coin()

func show_detail(index, type):
	ItemDetailContainer.visible = true
	var item_code
	if type == "buy":
		item_code = item_buy_dict[index]["code"]
		
	elif type == "sell":
		item_code = item_sell_dict[index]["code"]

	var item = items[item_code]
	ItemDetailContainer.get_node("Panel/ItemName").text = item["item_name"]
	ItemDetailContainer.get_node("Panel/ItemDescription").text = item["item_description"]
	if item["affect_player"] == true:
		ItemDetailContainer.get_node("Panel/ItemEffect").text = ""
		for effect in item["effect"]:
			ItemDetailContainer.get_node("Panel/ItemEffect").text += (str(effect) + "->" + str(item["effect"][effect])) + "\n" 
	else:
		ItemDetailContainer.get_node("Panel/ItemEffect").text = "효과없음"

func close_detail():
	ItemDetailContainer.visible = false

func _on_sell_item(index):
	var item_code = item_sell_dict[index]["code"]
	var item = {
		"code" : item_sell_dict[index]["code"],
		"numberof" : 1,
		"type" : items[item_code]["type"]
	}
	emit_signal("sell_item", item)
	
func _on_buy_item(index):
	var item_code = item_buy_dict[index]["code"]
	var item = {
		"code" : item_code,
		"numberof" : 1,
		"type" : items[item_code]["type"]
	}
	emit_signal("buy_item", item)


func _on_Exit_pressed() -> void:
	queue_free()


func _on_change_inven_type(extra_arg_0: String) -> void:
	current_inven_type = extra_arg_0
	update_shop()
