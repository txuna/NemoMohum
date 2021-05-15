extends Node2D

onready var DamageContainer = $DamageContainer
onready var tween = $Tween
onready var TestContainer = $Control

export var travel = Vector2(0, -80)
export var duration = 2
export var spread = PI/2

var count = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
	
func float_image(string_damage:String, damage_image_dict:Dictionary):
	var damage_box = HBoxContainer.new() 
	damage_box.alignment = 2
	for damage_number in string_damage:
		var texture_rect = TextureRect.new()
		texture_rect.texture = damage_image_dict[int(damage_number)]
		#DamageContainer.add_child(texture_rect)
		damage_box.add_child(texture_rect)
	
	TestContainer.add_child(damage_box)
	damage_box.rect_position = Vector2(0, -70 * count)
	
	#tween.interpolate_property(DamageContainer, "rect_position", Vector2(0,0), Vector2(30, -50), 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.interpolate_property(damage_box, "rect_position", damage_box.rect_position, damage_box.rect_position+Vector2(30, -70), 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	yield(tween, "tween_all_completed") #tween_all_completed 시그널을 받으면 다시 실행
	#queue_free()


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
	
func show_value2(damage_list, enemy=true):
	var timer = Timer.new() 
	timer.wait_time = 0.1
	timer.connect("timeout", self, "_on_Timer_show_next_value", [damage_list, enemy])
	add_child(timer)
	timer.start()

# 좀 더 우아하게 종료할 수 있도록 연구하기 @@TODO
func _on_Timer_show_next_value(damage_list, enemy):
	if count >= damage_list.size():
		return 
		
	var damage = damage_list[count]["damage"]
	var crit = damage_list[count]["crit"]
	var index = damage_list[count]["index"]
	show_value(damage, crit, enemy)
	count+=1

func _on_Timer_timeout() -> void:
	queue_free()













