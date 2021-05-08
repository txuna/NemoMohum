extends KinematicBody2D


var velocity:Vector2 = Vector2.ZERO
const GRAVITY = 80

signal GiveSpoil

var item_info = {
	"numberof" : null,
	"code" : null,
	"type" : null,
}

var item_code = null
var numberof = null
var item_type = null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.play("spoil")
	item_info["code"] = item_code
	item_info["numberof"] = numberof
	item_info["type"] = item_type

func _physics_process(delta: float) -> void:
	if is_on_floor():
		set_physics_process(false)
	velocity.y += GRAVITY
	move_and_slide(velocity, Vector2.UP)

func setup_item(spoil_item_code: int, spoil_numberof: int, spoil_type:String):
	item_code = spoil_item_code
	numberof = spoil_numberof
	item_type = spoil_type

func get_item():
	return item_info
	
func _on_Area2D_body_entered(body: Node) -> void:
	emit_signal("GiveSpoil", get_item())
	queue_free()

