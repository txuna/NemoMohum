extends Node

# 기본 공격 스킬 

var BasicSkills = {
	0xE000 : {
		"skill_name" : "Basic Sword Attack",
		"skill_code" : 0xE000,
		"hit_number" : 1,
		"enemy_number" : 1,
		"damage_percent" : 100,
		"skill_scene" : preload("res://src/Skill/BasicSword/BasicSword.tscn"),
		"skill_effect" : null,
		"skill_hit_effect" : "",
		"skill_type" : "Active",
		"acquire" : true, 
		"skill_level" : 1, 
		"master_level" : 1,
		"level_effect" : {
			"damage_percent" : 0,
		},
		"mp" : 0,
	},
	0xE001 : {
		"skill_name" : "Basic Bow Attack",
		"skill_code" : 0xE001,
		"hit_number" : 1,
		"enemy_number" : 1,
		"damage_percent" : 100,		
		"skill_scene" : preload("res://src/Skill/BasicArrow/BasicArrow.tscn"),
		"skill_effect" : null,
		"skill_hit_effect" : "",
		"skill_type" : "Active",
		"acquire" : true, 
		"skill_level" : 1, 
		"master_level" : 1,
		"level_effect" : {
			"damage_percent" : 0,
		},
		"mp" : 0,
	},
	0xE002 : {
		"skill_name" : "Basic Gun Attack",
		"skill_code" : 0xE002,
		"hit_number" : 1,
		"enemy_number" : 1,
		"damage_percent" : 100,		
		"skill_scene" :preload("res://src/Skill/BasicBullet/BasicBullet.tscn"),
		"skill_effect" : null,
		"skill_hit_effect" : "",
		"skill_type" : "Active",
		"acquire" : true, 
		"skill_level" : 0, 
		"master_level" : 10,
		"level_effect" : {
			"damage_percent" : 0,
		},
		"mp" : 0,
	},
}
#precedence_skill_code
# level_effect는 레벨업당 증가하는 스탯
# 공격 스킬들 
# Active and Passive and Buff
var Skills = {
	0xE003: {
		"skill_name" : "폭탄 총알",
		"skill_description" : "액티브 스킬이다.\n1명의 적에게 1번 공격한다.\n 데미지는 200%로 공격한다.\n 마스터레벨은 10이다.\n레벨업당 데미지가 30%증가한다.\n마나는 20만큼 소모한다.",
		"skill_code" : 0xE003,
		"hit_number" : 1, 
		"enemy_number" : 1,
		"damage_percent" : 200,
		"skill_type" : "Active",
		"skill_scene" : preload("res://src/Skill/BasicBullet/BasicBullet.tscn"),
		"skill_effect" : preload("res://src/Effect/HitEffect.tscn"),
		"skill_hit_effect" : preload("res://src/Effect/HitEffect.tscn"),
		"mp" : 20,
		"acquire" : false, 
		"precedence_skill_code" : [],
		"skill_level" : 0, 
		"master_level" : 10,
		"level_effect" : {
			"damage_percent" : 30,
		},
		"type" : "Gun",
		"image" : load("res://assets/art/icon/skill_bomb_bullet_icon.png"),
	},
	0xE004: {
		"skill_name" : "피지컬 업그레이드",
		"skil_code" : 0xE004,
		"skill_type" : "Passive",
		"skill_description" : "패시브 스킬이다.\n 마스터레벨은 1이며 최대 체력 3000이 늘어난다.",
		"mp" : 0,
		"acquire" : false, 
		"precedence_skill_code" : [],
		"skill_level" : 0, 
		"master_level" : 1,
		"level_effect" : {
			"max_hp" : 3000,
		},
		"type" : "Gun",
		"image" : load("res://assets/art/icon/skill_physical_training_icon.png"),
	},
	0xE005: {
		"skill_name" : "벌크업",
		"skill_code" : 0xE005,
		"skill_type" : "Buff",
		"skill_description" : "버프 스킬이다.\n 마스터 레벨은 1이며 사용시 10초동안 최대 체력5000, 치명타 데미지 100, 치명타 확률 50이 증가한다.\n",
		"buff_duration" : 10, # Second
		"skill_scene" : "",
		"skill_effect" : preload("res://src/Effect/HitEffect.tscn"),
		"mp" : 20,
		"acquire" : false, 
		"precedence_skill_code" : [],
		"skill_level" : 0, 
		"master_level" : 1,
		"level_effect" : {
			"max_hp" : 5000,
			"crit_damage" : 100,
			"crit" : 50,
		},
		"type" : "Gun",
		"image" : load("res://assets/art/icon/skill_bulkup_icon.png"),
	},
}

func check_master_level(code):
	if  Skills[code]["skill_level"] < Skills[code]["master_level"]:
		return true 
	else:
		return false

func check_accquire_skill(code):
	if Skills[code]["acquire"] == true:
		return true
	else:
		return false

func check_precedence(code):
	for skill_code in Skills[code]["precedence_skill_code"]:
		if check_accquire_skill(code):
			continue
		else:
			return false
			
	return true

func upgrade_skill(code):
	Skills[code]["skill_level"] +=1
	if Skills[code]["acquire"] == false:
		Skills[code]["acquire"] = true
		
	if Skills[code]["skill_type"] == "Passive":
		var player_variables = get_node("/root/PlayerVariables")
		player_variables.increase_state_from_effect(Skills[code]["level_effect"], 1)
