extends Area2D

const RIGHT = false
const LEFT = true

const SKILL_ATTACK = true 
const NORMAL_ATTACK = false


onready var sprite = $Sprite
onready var animation_player = $AnimationPlayer
var skill = null
var player_state = null
var skill_direction = null

var enemy_number:int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# 여기서 type은 기본 공격이냐 스킬공격이냐 결정짓는 파라미터 true: skill attack \ false : normal attack
func set_skill(code:int, type:bool, state:Dictionary):
	if type == SKILL_ATTACK:
		skill = get_node("/root/Skills").Skills[code]
		
	elif type == NORMAL_ATTACK:
		skill = get_node("/root/Skills").BasicSkills[code]
	
	player_state = state
	animation_player.play("shot")

func set_direction(direction):
	if direction == RIGHT:
		skill_direction = 1
	else:
		skill_direction = -1
	
	sprite.flip_h = direction


# Enemy와의 접촉
func _on_BaseSkill_body_entered(body: Node) -> void:
	if body.is_in_group("enemies"):
		#enemy_number+=1
		# hit effect 를 몬스터 객체에 넣기
		if enemy_number < skill["enemy_number"]:
			for i in range(skill["hit_number"]):
				var crit
				var damage = int(rand_range(player_state["min_attack"], player_state["max_attack"]))
				damage = int(damage * (skill["damage_percent"] + (skill["level_effect"]["damage_percent"]) * skill["skill_level"]) / 100)
				var temp = rand_range(0, 10000)
				if temp <= (player_state["crit"] * 100):
					crit = true
					damage = int(damage * (player_state["crit_damage"] + 100) / 100) 
				else:
					crit = false
				body.take_damage(damage, crit, i)
			enemy_number+=1
			if enemy_number >= skill["enemy_number"]:
				queue_free()
