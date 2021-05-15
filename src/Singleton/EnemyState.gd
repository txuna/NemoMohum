class_name EnemyState

var EnemyList = {
	0xF003 : {
		"enemy_code" : 0xF003,
		"enemy_name" : "Frog",
		"state" : {
			"attack" : 50,
			"def" : 40, 
			"max_hp" : 250,
			"current_hp" : 250,
			"speed" : 30,
			"level" : 1,
		},
		"spoil" : {
			"coin" : 10,
			"exp" : 570,
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
				{
					"code" : 0xC000,
					"numberof" : 1,
					"percentage" : 100,
				},
				{
					"code" : 0xC001,
					"numberof" : 1,
					"percentage" : 100,
				}
			]
		}
	},
	0xF004 : {
		"enemy_code" : 0xF004,
		"enemy_name" : "Rabbit",
		"state" : {
			"attack" : 60,
			"def" : 30, 
			"max_hp" : 250,
			"current_hp" : 250,
			"speed" : 70,
			"level" : 3,
		},
		"spoil" : {
			"coin" : 15,
			"exp" : 2000,
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
				{
					"code" : 0xC002,
					"numberof" : 1,
					"percentage" : 100,
				},
			]
		}
	},
	0xF005 : {
		"enemy_code" : 0xF005,
		"enemy_name" : "Squirrel",
		"state" : {
			"attack" : 20,
			"def" : 70, 
			"max_hp" : 250,
			"current_hp" : 250,
			"speed" : 90,
			"level" : 5,
		},
		"spoil" : {
			"coin" : 15,
			"exp" : 2000,
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
				{
					"code" : 0xC003,
					"numberof" : 1,
					"percentage" : 100,
				},
			]
		}
	},
	0xF006 : {
		"enemy_code" : 0xF006,
		"enemy_name" : "Spearman",
		"state" : {
			"attack" : 20,
			"def" : 70, 
			"max_hp" : 250,
			"current_hp" : 250,
			"speed" : 90,
			"level" : 5,
		},
		"spoil" : {
			"coin" : 15,
			"exp" : 2000,
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
	0xF007 : {
		"enemy_code" : 0xF007,
		"enemy_name" : "Swordman",
		"state" : {
			"attack" : 50,
			"def" : 100, 
			"max_hp" : 250000,
			"current_hp" : 250000,
			"speed" : 130,
			"level" : 5,
		},
		"spoil" : {
			"coin" : 15,
			"exp" : 2000,
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
	0xF008 : {
		"enemy_code" : 0xF008,
		"enemy_name" : "Sentryman",
		"state" : {
			"attack" : 70,
			"def" : 20, 
			"max_hp" : 250,
			"current_hp" : 250,
			"speed" : 130,
			"level" : 5,
		},
		"spoil" : {
			"coin" : 15,
			"exp" : 2000,
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
}
#
func get_enemy_info(enemy_code):
	return EnemyList[enemy_code]
