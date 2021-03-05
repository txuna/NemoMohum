extends Node2D

onready var DamageContainer = $DamageContainer



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
func float_image(damage:int, damage_image_dict:Dictionary):
	while true:
		var damage_number = damage % 10 
		damage = int(damage / 10)
		var texture_rect = TextureRect.new()
		texture_rect.texture = damage_image_dict[damage_number]
		DamageContainer.add_child(texture_rect)
		if damage <= 0:
			return

func show_value(damage, crit=false, enemy=true):
	var damage_image_dict = null
	if enemy == true:
		if crit == true:
			damage_image_dict = get_node("/root/DamageImage").crit_image
		else:
			damage_image_dict = get_node("/root/DamageImage").no_crit_image
	else:
		damage_image_dict = get_node("/root/DamageImage").get_hit_image
	float_image(damage, damage_image_dict)


func _on_Timer_timeout() -> void:
	queue_free()
