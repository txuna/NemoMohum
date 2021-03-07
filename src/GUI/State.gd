extends CanvasLayer

onready var attack = $Sprite/AttackContainer/Value
onready var def = $Sprite/DefContainer/Value
onready var crit = $Sprite/CritContainer/Value
onready var crit_damage = $Sprite/CritDamageContainer/Value
onready var hp = $Sprite/HpContainer/Value
onready var mp = $Sprite/MpContainer/Value
onready var level = $Sprite/LevelContainer/Value
onready var nickname = $Sprite/NameContainer/Value
onready var upgrade_point = $Sprite/UpgradePoint/Value

onready var attack_btn = $Sprite/AttackContainer/Button
onready var def_btn = $Sprite/DefContainer/Button
onready var crit_btn = $Sprite/CritContainer/Button
onready var crit_damage_btn = $Sprite/CritDamageContainer/Button
onready var hp_btn = $Sprite/HpContainer/Button
onready var mp_btn = $Sprite/MpContainer/Button


var player_variable = null
var player_state = null
signal upgrade_state

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_state = get_node("/root/PlayerVariables").state
	update_state()

func set_disabled_button(upgrade_point):
	var mask = false
	if upgrade_point <= 0:
		mask = true
		
	attack_btn.disabled = mask
	def_btn.disabled = mask 
	crit_btn.disabled = mask 
	crit_damage_btn.disabled = mask 
	hp_btn.disabled = mask 
	mp_btn.disabled = mask 
	
	
func update_state():
	set_disabled_button(player_state["upgrade_point"])
	attack.text = str(player_state["min_attack"]) + "~" + str(player_state["max_attack"])
	def.text = str(player_state["def"])
	crit.text = str(player_state["crit"])
	crit_damage.text = str(player_state["crit_damage"])
	hp.text = str(player_state["current_hp"]) +"/" + str(player_state["max_hp"])
	mp.text = str(player_state["current_mp"]) + "/" + str(player_state["max_mp"])
	level.text = str(player_state["level"])
	nickname.text = str(player_state["nickname"])
	upgrade_point.text = str(player_state["upgrade_point"])
	
	
func _on_upgrade_state(extra_arg_0: String) -> void:
	emit_signal("upgrade_state", extra_arg_0)
