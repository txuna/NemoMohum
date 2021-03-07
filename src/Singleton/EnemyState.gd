extends Node

var EnemyList = {
	0xF000 : {
		"enemy_name" : "rose",
		"state" : {
			"attack" : 30,
			"def" : 40, 
			"max_hp" : 250,
			"current_hp" : 250,
			"speed" : 0,
			"level" : 1,
		},
		"spoil" : {
			"coin" : 10,
			"exp" : 5000,
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
