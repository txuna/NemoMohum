extends "res://src/Enemy/Enemy.gd"

func _ready() -> void:
	set_enemy_info(0xF006)

func _on_AttackArea_body_entered(body: Node) -> void:
	skill_attack("res://src/Enemy/EnemySkill/StingSkill.tscn")
