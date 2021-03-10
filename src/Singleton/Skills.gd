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
		"skill_effect" : "",
		"skill_hit_effect" : "",
		"mp" : 0,
	},
	0xE001 : {
		"skill_name" : "Basic Bow Attack",
		"skill_code" : 0xE001,
		"hit_number" : 1,
		"enemy_number" : 1,
		"damage_percent" : 100,		
		"skill_scene" : preload("res://src/Skill/BasicArrow/BasicArrow.tscn"),
		"skill_effect" : "",
		"skill_hit_effect" : "",
		"mp" : 0,
	},
	0xE002 : {
		"skill_name" : "Basic Gun Attack",
		"skill_code" : 0xE002,
		"hit_number" : 1,
		"enemy_number" : 1,
		"damage_percent" : 100,		
		"skill_scene" :preload("res://src/Skill/BasicBullet/BasicBullet.tscn"),
		"skill_effect" : "",
		"skill_hit_effect" : "",
		"mp" : 0,
	},
}
#precedence_skill_code
# level_effect는 레벨업당 증가하는 스탯
# 공격 스킬들 
var Skills = {
	0xE003: {
		"skill_name" : "폭탄 총알",
		"skil_code" : 0xE003,
		"hit_number" : 1, 
		"enemy_number" : 1,
		"damage_percent" : 200,
		"skill_scene" : "",
		"skill_effect" : "",
		"skill_hit_effect" : "",
		"mp" : 0,
		"accquire" : false, 
		"precedence_skill_code" : [],
		"skill_level" : 0, 
		"level_effect" : {
			"damage_percent" : 30,
		},
		"type" : "Gun",
		"image" : "res://assets/art/player/player.png",
	}
}
