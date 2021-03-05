extends Node2D

onready var DamageContainer = $DamageContainer

var no_crit_image = {
	"0" : load("res://assets/art/damage_skin/damage_number/NoRed0.0.png"),
	"1" : load("res://assets/art/damage_skin/damage_number/NoRed0.1.png"),
	"2" : load("res://assets/art/damage_skin/damage_number/NoRed0.2.png"),
	"3" : load("res://assets/art/damage_skin/damage_number/NoRed0.3.png"),
	"4" : load("res://assets/art/damage_skin/damage_number/NoRed0.4.png"),
	"5" : load("res://assets/art/damage_skin/damage_number/NoRed0.5.png"),
	"6" : load("res://assets/art/damage_skin/damage_number/NoRed0.6.png"),
	"7" : load("res://assets/art/damage_skin/damage_number/NoRed0.7.png"),
	"8" : load("res://assets/art/damage_skin/damage_number/NoRed0.8.png"),
	"9" : load("res://assets/art/damage_skin/damage_number/NoRed0.9.png"),
}

var crit_image = {
	"0" : load("res://assets/art/damage_skin/crit_damage_number/NoCri0.0.png"),
	"1" : load("res://assets/art/damage_skin/crit_damage_number/NoCri0.1.png"),
	"2" : load("res://assets/art/damage_skin/crit_damage_number/NoCri0.2.png"),
	"3" : load("res://assets/art/damage_skin/crit_damage_number/NoCri0.3.png"),
	"4" : load("res://assets/art/damage_skin/crit_damage_number/NoCri0.4.png"),
	"5" : load("res://assets/art/damage_skin/crit_damage_number/NoCri0.5.png"),
	"6" : load("res://assets/art/damage_skin/crit_damage_number/NoCri0.6.png"),
	"7" : load("res://assets/art/damage_skin/crit_damage_number/NoCri0.7.png"),
	"8" : load("res://assets/art/damage_skin/crit_damage_number/NoCri0.8.png"),
	"9" : load("res://assets/art/damage_skin/crit_damage_number/NoCri0.9.png"),
}

var get_hit_image = {
	"0" : load("res://assets/art/damage_skin/get_hit_damage_number/NoViolet0.0.png"),
	"1" : load("res://assets/art/damage_skin/get_hit_damage_number/NoViolet0.1.png"),
	"2" : load("res://assets/art/damage_skin/get_hit_damage_number/NoViolet0.2.png"),
	"3" : load("res://assets/art/damage_skin/get_hit_damage_number/NoViolet0.3.png"),
	"4" : load("res://assets/art/damage_skin/get_hit_damage_number/NoViolet0.4.png"),
	"5" : load("res://assets/art/damage_skin/get_hit_damage_number/NoViolet0.5.png"),
	"6" : load("res://assets/art/damage_skin/get_hit_damage_number/NoViolet0.6.png"),
	"7" : load("res://assets/art/damage_skin/get_hit_damage_number/NoViolet0.7.png"),
	"8" : load("res://assets/art/damage_skin/get_hit_damage_number/NoViolet0.8.png"),
	"9" : load("res://assets/art/damage_skin/get_hit_damage_number/NoViolet0.9.png"),
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
func float_image(string_damage:String, damage_image_dict:Dictionary):
	for damage_number in string_damage:
		var texture_rect = TextureRect.new()
		texture_rect.texture = damage_image_dict[damage_number]
		DamageContainer.add_child(texture_rect)


func show_value(damage, crit=false, enemy=true):
	var string_damage = str(damage)
	var damage_image_dict = null
	if enemy == true:
		if crit == true:
			damage_image_dict = crit_image
		else:
			damage_image_dict = no_crit_image
	else:
		damage_image_dict = get_hit_image
	float_image(string_damage, damage_image_dict)


func _on_Timer_timeout() -> void:
	queue_free()
