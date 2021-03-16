class_name Npcs

var NpcList = {
	0x9000 : {
		"code" : 0x9000,
		"name" : "미아",
		"description" : "잡화상점",
		"type" : "shopkeeper",
		"image" : load("res://assets/art/npc/mia/mia1.png"),
		"scene" : "res://src/Npc/Mia.tscn",
		"base_msg" : "내가 관상을 볼줄 알어.... 넌 글렀어 임마...",
	},
	0x9001:{
		"code" : 0x9001,
		"name" : "스탄",
		"description" : "커닝시티 갤주",
		"type" : "quest",
		"image" : load("res://assets/art/npc/stan/stan.png"),
		"scene" : "res://src/Npc/Stan.tscn",
		"base_msg" : "내가 관상을 볼줄 알어.... 넌 글렀어 임마...",
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
