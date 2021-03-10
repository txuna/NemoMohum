extends KinematicBody2D

const GRAVITY = 800
var velocity = Vector2.ZERO

onready var sprite = $Sprite
var npc = null
var player_variable = null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_variable = get_node("/root/PlayerVariables")

func _physics_process(delta: float) -> void:
	velocity.y += GRAVITY
	move_and_slide(velocity, Vector2.UP)


func set_npc(npc_code):
	npc = get_node("/root/Npcs").Npcs[npc_code]
	sprite.texture = npc["image"]
	sprite.scale = Vector2(0.1, 0.1)

func _on_BaseNpc_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		if npc["type"] == "shopkeeper":
			open_shop(npc["code"])

func open_shop(npc_code):
	var shop_node = get_node_or_null("/root/Main/Shop")
	if shop_node != null:
		shop_node.queue_free()
		
	var player_node_path = player_variable.get_player_node_path()
	var player_node = get_node(player_node_path)
	shop_node = preload("res://src/GUI/Shop.tscn").instance()
	shop_node.connect("sell_item", player_node, "_on_sell_item")
	shop_node.connect("buy_item", player_node, "_on_buy_item")
	get_node("/root/Main").add_child(shop_node)
	shop_node.open_shop(npc_code)