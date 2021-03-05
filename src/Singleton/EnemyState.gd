extends Node

var EnemyList = {
	0xF000 : {
		"enemy_name" : "rose",
		"state" : {
			"attack" : 30,
			"def" : 40, 
			"max_hp" : 25,
			"current_hp" : 25,
			"speed" : 0,
			"level" : 1,
		},
		"spoil" : {
			"coin" : 10,
			"exp" : 10,
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
