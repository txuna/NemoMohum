extends CanvasLayer

onready var hpbar = $Control/TextureRect/HpProgressBar
onready var mpbar = $Control/TextureRect/MpProgressBar
onready var expbar = $Control/TextureRect/ExpProgressBar

onready var hpvalue = $Control/TextureRect/HpContainer/Value
onready var mpvalue = $Control/TextureRect/MpContainer/Value
onready var expvalue = $Control/TextureRect/ExpContainer/Value

onready var nickname = $Control/TextureRect/InfoBack/NameValue
onready var level = $Control/TextureRect/InfoBack/LevelValue

onready var update_tween = $Control/TextureRect/Tween

var player_state = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_state = get_node("/root/PlayerVariables").state
	setup_hud()

func update_hud(value, type):
	var bar = null
	var max_name = "max_" + type
	var value_name = "current_" + type
	var textvalue = null 
	
	if type == "hp":
		bar = hpbar
		textvalue = hpvalue
	elif type == "mp":
		bar = mpbar
		textvalue = mpvalue
	elif type == "exp":
		bar = expbar 
		textvalue = expvalue
	change_progressbar(value, bar, textvalue, max_name, value_name)
	
func change_progressbar(value, bar, textvalue, max_value_name, value_name):
	level.text = str(player_state["level"])
	expvalue.text = "[" + str(player_state[value_name]) + "/" + str(player_state[max_value_name]) + "]"
	textvalue.text = "[" + str(player_state[value_name]) + "/" + str(player_state[max_value_name]) + "]"
	var current_value = bar.value 
	bar.value += value 
	update_tween.interpolate_property(bar, "value", current_value, bar.value, 0.4, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	yield(update_tween, "tween_all_completed")
	
func setup_hud():
	level.text = str(player_state["level"])
	nickname.text = player_state["nickname"]
	
	hpbar.max_value = player_state["max_hp"]
	hpbar.value = player_state["current_hp"]
	hpvalue.text = "[" + str(player_state["current_hp"]) + "/" + str(player_state["max_hp"]) + "]"
	
	mpbar.max_value = player_state["max_mp"]
	mpbar.value = player_state["current_mp"]
	mpvalue.text = "[" + str(player_state["current_mp"]) + "/" + str(player_state["max_mp"]) + "]"
	
	expbar.max_value = player_state["max_exp"]
	expbar.value = player_state["current_exp"]
	expvalue.text = "[" + str(player_state["current_exp"]) + "/" + str(player_state["max_exp"]) + "]"
	
