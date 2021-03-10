extends Node2D

onready var DamageContainer = $DamageContainer

export var travel = Vector2(0, -80)
export var duration = 2
export var spread = PI/2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
func float_image(string_damage:String, damage_image_dict:Dictionary):
	for damage_number in string_damage:
		var texture_rect = TextureRect.new()
		texture_rect.texture = damage_image_dict[int(damage_number)]
		DamageContainer.add_child(texture_rect)


func show_value(damage, crit=false, enemy=true):
	var damage_image_dict = null
	if enemy == true:
		if crit == true:
			damage_image_dict = get_node("/root/DamageImage").crit_image
		else:
			damage_image_dict = get_node("/root/DamageImage").no_crit_image
	else:
		damage_image_dict = get_node("/root/DamageImage").get_hit_image
	float_image(str(damage), damage_image_dict)


func _on_Timer_timeout() -> void:
	queue_free()
