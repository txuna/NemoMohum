extends KinematicBody2D

const GRAVITY = 800
var velocity = Vector2.ZERO

onready var npc_name = $NpcName
onready var sprite = $Sprite

var npc = null
var player_variable = null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_variable = get_node("/root/PlayerVariables")

func _physics_process(delta: float) -> void:
	if is_on_floor():
		set_physics_process(false)
	velocity.y += GRAVITY
	move_and_slide(velocity, Vector2.UP)



func set_npc(npc_code):
	npc = Npcs.new().NpcList[npc_code]
	#npc = get_node("/root/Npcs").Npcs[npc_code]
	sprite.texture = npc["image"]
	npc_name.text = npc["name"] + "\n" + npc["description"]

func _on_BaseNpc_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		if npc["type"] == "shopkeeper":
			open_shop(npc["code"])
			
		elif npc["type"] == "quest": #대화상자 오픈
			open_chatbox(npc["code"], npc["base_msg"], npc["name"])
			
		elif npc["type"] == "enchant":
			open_enchant()

func open_enchant():
	var enchant_node = get_node_or_null("/root/Main/EnchantUI")
	if enchant_node != null:
		enchant_node.queue_free()
	
	enchant_node = load("res://src/GUI/EnchantUI.tscn").instance()
	get_node("/root/Main").add_child(enchant_node)

func open_chatbox(npc_code:int, base_msg:String, name:String):
	var chatbox_node = get_node_or_null("/root/Main/Chatbox")
	if chatbox_node != null:
		chatbox_node.queue_free()

	chatbox_node = load("res://src/GUI/Chatbox.tscn").instance()
	get_node("/root/Main").add_child(chatbox_node)
	chatbox_node.load_possible_quest(npc_code, base_msg, name)
	

func open_shop(npc_code):
	var shop_node = get_node_or_null("/root/Main/Shop")
	if shop_node != null:
		shop_node.queue_free()
		
	var player_node_path = player_variable.get_player_node_path()
	var player_node = get_node(player_node_path)
	shop_node = load("res://src/GUI/Shop.tscn").instance()
	shop_node.connect("sell_item", player_node, "_on_sell_item")
	shop_node.connect("buy_item", player_node, "_on_buy_item")
	get_node("/root/Main").add_child(shop_node)
	shop_node.open_shop(npc_code)
