class_name Npcs

var NpcList = {
	0x9000 : {
		"code" : 0x9000,
		"name" : "Mia",
		"description" : "shop",
		"type" : "shopkeeper",
		"image" : load("res://assets/art/npc/mia/mia3.png"),
		"base_msg" : "HI",
	},
	0x9001:{
		"code" : 0x9001,
		"name" : "Stan",
		"description" : "npc",
		"type" : "quest",
		"image" : load("res://assets/art/npc/stan/stan2.png"),
		"base_msg" : "HI",
	},
	0x9002:{
		"code" : 0x9002,
		"name" : "Kale",
		"description" : "npc",
		"type" : "quest",
		"image" : load("res://assets/art/npc/kale/kale.png"),
		"base_msg" : "HI",
	},
	0x9003:{
		"code" : 0x9003,
		"name" : "alex",
		"description" : "npc",
		"type" : "quest",
		"image" : load("res://assets/art/npc/alex/alex.png"),
		"base_msg" : "HI",
	},
	0x9004:{
		"code" : 0x9004,
		"name" : "juho",
		"description" : "hi",
		"type" : "quest",
		"image" : load("res://assets/art/npc/juho/juho.png"),
		"base_msg" : "HI",
	},
	0x9005:{
		"code" : 0x9005,
		"name" : "muyaho",
		"description" : "npc",
		"type" : "quest",
		"image" : load("res://assets/art/npc/muyaho/muyaho.png"),
		"base_msg" : "HI",
	},
	0x9006:{
		"code" : 0x9006,
		"name" : "aemerican",
		"description" : "npc",
		"type" : "quest",
		"image" : load("res://assets/art/npc/american/american.png"),
		"base_msg" : "HI",
	}
}

# shop product
var ShopKeepers = {
	0x9000 : [
		{
			"code" : 0xA000
		},
		{
			"code" : 0xB000
		},
		{
			"code" : 0xB001
		},
	],
}
