extends "res://src/Enemy/Enemy.gd"

func _ready() -> void:
	set_enemy_info(0xF009)
	set_skill("res://src/Enemy/EnemySkill/BulletSkill2.tscn")
