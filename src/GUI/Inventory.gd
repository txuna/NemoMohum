extends CanvasLayer

var items = null

onready var slot_grid = $Sprite/ScrollContainer/GridContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	items = get_node("/root/Items").Items


func make_slot()->Panel:
	var slot = Panel.new()
	var item_image = Sprite.new()
	var numberof_label = Label.new() 
	return slot
	
func load_slot_from_inventory():
	pass
	
func show_item_detail():
	pass
