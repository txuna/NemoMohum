class_name Npcs

var NpcList = {
	0x9000 : {
		"code" : 0x9000,
		"name" : "미아",
		"description" : "상점",
		"type" : "shopkeeper",
		"image" : load("res://assets/art/npc/mia/mia3.png"),
		"base_msg" : "HI",
	},
	0x9001:{
		"code" : 0x9001,
		"name" : "스탄",
		"description" : "시민",
		"type" : "quest",
		"image" : load("res://assets/art/npc/stan/stan2.png"),
		"base_msg" : "늅ㅎㅇㅎㅇ ㅋㅋ",
	},
	0x9002:{
		"code" : 0x9002,
		"name" : "카일",
		"description" : "시민",
		"type" : "quest",
		"image" : load("res://assets/art/npc/kale/kale.png"),
		"base_msg" : "도토리 축제가 한창이란 말이지 ...",
	},
	0x9003:{
		"code" : 0x9003,
		"name" : "알렉스",
		"description" : "시민",
		"type" : "quest",
		"image" : load("res://assets/art/npc/alex/alex.png"),
		"base_msg" : "노숙중, 말걸면 물음",
	},
	0x9004:{
		"code" : 0x9004,
		"name" : "주호",
		"description" : "시민",
		"type" : "quest",
		"image" : load("res://assets/art/npc/juho/juho.png"),
		"base_msg" : "방가방가",
	},
	0x9005:{
		"code" : 0x9005,
		"name" : "무야호",
		"description" : "시민",
		"type" : "quest",
		"image" : load("res://assets/art/npc/muyaho/muyaho.png"),
		"base_msg" : "방가방가",
	},
	0x9006:{
		"code" : 0x9006,
		"name" : "아메리칸",
		"description" : "장비강화",
		"type" : "enchant",
		"image" : load("res://assets/art/npc/american/american.png"),
		"base_msg" : "강화해드림!",
	}
}

# shop product
var ShopKeepers = {
	0x9000 : [
		{
			"code" : 0xC001
		},
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
