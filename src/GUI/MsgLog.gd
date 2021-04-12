extends CanvasLayer

onready var msg_container = $ScrollContainer/MsgContainer

var color = "#F1C234"

var count = 0

func _ready() -> void:
	pass

func make_dynamic_font(font_size)->DynamicFont:
	# font 설정
	var dynamic_font = DynamicFont.new()
	dynamic_font.font_data = load("res://assets/fonts/NanumSquareRoundB.ttf")
	dynamic_font.size = font_size
	return dynamic_font	

func add_message(msg:String):
	var label = Label.new() 
	label.name = str(count)
	label.set("custom_fonts/font", make_dynamic_font(48))
	label.set("custom_colors/font_color",Color(0xf1,0xc2,0x34))
	label.text = msg
	
	var tween = Tween.new() 
	tween.name = "TweenNode"
	label.add_child(tween)
	msg_container.add_child(label)
	
	label.get_node("TweenNode").interpolate_property(label, "custom_colors/font_color", Color(1, 0.5, 0, 1), Color(1, 0.5, 0, 0), 6, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	label.get_node("TweenNode").start()
	label.get_node("TweenNode").connect("tween_all_completed", self, "_on_tween_completed", [str(count)])
	count+=1

func _on_tween_completed(label_name:String):
	msg_container.get_node(label_name).queue_free()









