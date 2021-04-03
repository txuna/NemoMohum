extends Node2D

signal game_start

onready var start_button = $Background/Button

func _ready() -> void:
	pass


func _on_game_start() -> void:
	emit_signal("game_start")
