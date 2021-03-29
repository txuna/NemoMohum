extends KinematicBody2D


var velocity = Vector2.ZERO
const GRAVITY = 80

var item_info = {
	"numberof" : null,
	"code" : null,
	"type" : null,
}

var item_code = null
var numberof = null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.play("spoil")
	var items = get_node("/root/Items").Items
	item_info["code"] = item_code
	item_info["numberof"] = numberof
	item_info["type"] = items[item_code]["type"]

func _physics_process(delta: float) -> void:
	if is_on_floor():
		set_physics_process(false)
	velocity.y += GRAVITY
	move_and_slide(velocity, Vector2.UP)

func setup_item(spoil_item_code: int, spoil_numberof: int):
	item_code = spoil_item_code
	numberof = spoil_numberof

func get_item():
	return item_info
