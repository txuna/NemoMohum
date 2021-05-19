class_name EnemyState

var EnemyList = {
	0xF006 : {
		"enemy_code" : 0xF006,
		"enemy_name" : "기사단의 창병",
		"state" : {
			"attack" : 20,
			"def" : 70, 
			"max_hp" : 200,
			"current_hp" : 200,
			"speed" : 70,
			"level" : 3,
		},
		"spoil" : {
			"coin" : 15,
			"exp" : 22,
			"item" : [
				{
					"code" : 0xB001,
					"numberof" : 1,
					"percentage" : 30, 
				},
				{
					"code" : 0xC006,
					"numberof" : 1,
					"percentage" : 30, 
				},
			]
		}
	},
	0xF007 : {
		"enemy_code" : 0xF007,
		"enemy_name" : "기사단의 검병",
		"state" : {
			"attack" : 10,
			"def" : 70, 
			"max_hp" : 100,
			"current_hp" : 100,
			"speed" : 70,
			"level" : 1,
		},
		"spoil" : {
			"coin" : 15,
			"exp" : 10,
			"item" : [
				{
					"code" : 0xB000,
					"numberof" : 1,
					"percentage" : 40, 
				},
				{
					"code" : 0xC006,
					"numberof" : 1,
					"percentage" : 30, 
				},
			]
		}
	},
	0xF008 : {
		"enemy_code" : 0xF008,
		"enemy_name" : "기사단의 경비병",
		"state" : {
			"attack" : 38,
			"def" : 120, 
			"max_hp" : 300,
			"current_hp" : 300,
			"speed" : 80,
			"level" : 6,
		},
		"spoil" : {
			"coin" : 15,
			"exp" : 35,
			"item" : [
				{
					"code" : 0xB000,
					"numberof" : 1,
					"percentage" : 30, 
				},
				{
					"code" : 0xB003,
					"numberof" : 1,
					"percentage" : 20, 
				},
			]
		}
	},
	0xF009 : {
		"enemy_code" : 0xF009,
		"enemy_name" : "GD003",
		"state" : {
			"attack" : 120,
			"def" : 200, 
			"max_hp" : 1000,
			"current_hp" : 1000,
			"speed" : 30,
			"level" : 12,
		},
		"spoil" : {
			"coin" : 15,
			"exp" : 4000,
			"item" : [
				{
					"code" : 0xB000,
					"numberof" : 1,
					"percentage" : 100, 
				},
				{
					"code" : 0xB001,
					"numberof" : 1,
					"percentage" : 100, 
				},
			]
		}
	},
	0xF00A : {
		"enemy_code" : 0xF00A,
		"enemy_name" : "기사단의 맨손병",
		"state" : {
			"attack" : 120,
			"def" : 70, 
			"max_hp" : 130,
			"current_hp" : 130,
			"speed" : 35,
			"level" : 2,
		},
		"spoil" : {
			"coin" : 15,
			"exp" : 13,
			"item" : [
				{
					"code" : 0xB000,
					"numberof" : 1,
					"percentage" : 20, 
				},
			]
		}
	},
	0xF00B : {
		"enemy_code" : 0xF00B,
		"enemy_name" : "기사단의 방패병",
		"state" : {
			"attack" : 22,
			"def" : 400, 
			"max_hp" : 1000,
			"current_hp" : 1000,
			"speed" : 30,
			"level" : 13,
		},
		"spoil" : {
			"coin" : 15,
			"exp" : 62,
			"item" : [
				{
					"code" : 0xB003,
					"numberof" : 1,
					"percentage" : 30, 
				},
				{
					"code" : 0xB002,
					"numberof" : 1,
					"percentage" : 20, 
				},
			]
		}
	},
	0xF00C : {
		"enemy_code" : 0xF00C,
		"enemy_name" : "기사단의 궁병",
		"state" : {
			"attack" : 45,
			"def" : 150, 
			"max_hp" : 500,
			"current_hp" : 500,
			"speed" : 75,
			"level" : 10,
		},
		"spoil" : {
			"coin" : 15,
			"exp" : 45,
			"item" : [
				{
					"code" : 0xB002,
					"numberof" : 1,
					"percentage" : 15, 
				},
			]
		}
	},
}
#
func get_enemy_info(enemy_code):
	return EnemyList[enemy_code]
