extends Node

var Npcs = {
	0x9000 : {
		"code" : 0x9000,
		"name" : "미아",
		"description" : "잡화상점",
		"type" : "shopkeeper",
		"image" : load("res://assets/art/npc/mia/mia1.png"),
	},
	0x9001:{
		"code" : 0x9001,
		"name" : "스탄",
		"description" : "커닝시티 갤주",
		"type" : "quest",
		"image" : load("res://assets/art/npc/stan/stan.png"),
	}
}


var ShopKeepers = {
	0x9000 : [
		{
			"code" : 0xB000
		},
		{
			"code" : 0xB001
		},
		{
			"code" : 0xA000
		}
	],
}
