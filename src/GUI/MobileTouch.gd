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
var is_a = false 
var is_b = false 
var is_c = false 
var is_d = false

onready var a_touch = $A
onready var b_touch = $B 
onready var c_touch = $C 
onready var d_touch = $D

var player_slot = null
var items = null
var skills = null
var slot_touch_dict = null

func _ready() -> void:
	player_slot = get_node("/root/PlayerVariables").get_quick_slot()
	items = get_node("/root/Items").Items
	skills = get_node("/root/Skills").Skills
	slot_touch_dict = {
		"A" : a_touch, 
		"B" : b_touch,
		"C" : c_touch, 
		"D" : d_touch, 
	}

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
		
	if is_a:
		emit_signal("Action", "A")
		is_a = false
	if is_b:
		emit_signal("Action", "B")
		is_b = false
	if is_c:
		emit_signal("Action", "C")
		is_c = false
	if is_d:
		emit_signal("Action", "D")
		is_d = false

func update_screen():
	for slot_key in player_slot:
		if player_slot[slot_key]["use"] == true:
			if player_slot[slot_key]["type"] == "consumption":
				slot_touch_dict[slot_key].normal = items[player_slot[slot_key]["code"]]["icon"]
				
			elif player_slot[slot_key]["type"] == "skill":
				slot_touch_dict[slot_key].normal = skills[player_slot[slot_key]["code"]]["image"]
				
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


func _on_A_pressed() -> void:
	is_a = true


func _on_B_pressed() -> void:
	is_b = true


func _on_C_pressed() -> void:
	is_c = true


func _on_D_pressed() -> void:
	is_d = true
