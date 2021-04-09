extends CanvasLayer

signal Action

var is_right = false
var is_left = false

var is_inventory = false 
var is_state = false 
var is_skill = false 
var is_quest = false 

var is_attack = false 
var is_jump = false

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	if is_right:
		emit_signal("Action", "Right")
	elif is_left:
		emit_signal("Action", "Left")
		
	if not is_right and not is_left:
		emit_signal("Action", "Stop")
		
	if is_inventory:
		emit_signal("Action", "Inventory")
		is_inventory = false
		
	if is_state:
		emit_signal("Action", "State")
		is_state = false
		
	if is_skill:
		emit_signal("Action", "Skill")
		is_skill = false
		
	if is_quest:
		emit_signal("Action", "Quest")
		is_quest = false
		
	if is_attack:
		emit_signal("Action", "Attack")
		is_attack = false
		
	if is_jump:
		emit_signal("Action", "Jump")
		is_jump = false

## 클릭되면 is_attack true하고 시그널 보내고 false


func _on_Inventory_pressed() -> void:
	is_inventory = true
	
func _on_Skill_pressed() -> void:
	is_skill = true

func _on_State_pressed() -> void:
	is_state = true

func _on_Quest_pressed() -> void:
	is_quest = true


func _on_Attack_pressed() -> void:
	is_attack = true


func _on_Jump_pressed() -> void:
	is_jump = true


func _on_Right_pressed() -> void:
	is_right = true


func _on_Right_released() -> void:
	is_right = false


func _on_Left_pressed() -> void:
	is_left = true


func _on_Left_released() -> void:
	is_left = false
