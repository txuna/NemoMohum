class_name EnemyState

var EnemyList = {
	0xF001 : {
		"enemy_code" : 0xF001,
		"enemy_name" : "robot",
		#"scene" : preload("res://src/Enemy/robot/Robot.tscn"),
		"state" : {
			"attack" : 50,
			"def" : 40, 
			"max_hp" : 250,
			"current_hp" : 250,
			"speed" : 70,
			"level" : 1,
		},
		"spoil" : {
			"coin" : 10,
			"exp" : 50000,
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
				}
			]
		}
	},
	0xF002 : {
		"enemy_code" : 0xF002,
		"enemy_name" : "toy robot",
		#"scene" : preload("res://src/Enemy/toyrobot/ToyRobot.tscn"),
		"state" : {
			"attack" : 50,
			"def" : 40, 
			"max_hp" : 250,
			"current_hp" : 250,
			"speed" : 70,
			"level" : 1,
		},
		"spoil" : {
			"coin" : 10,
			"exp" : 50000,
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
				}
			]
		}
	},
}

func get_enemy_info(enemy_code):
	return EnemyList[enemy_code]
