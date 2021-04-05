class_name Npcs

var NpcList = {
	0x9000 : {
		"code" : 0x9000,
		"name" : "헤네시스 죽박이 미아",
		"description" : "잡화상점",
		"type" : "shopkeeper",
		"image" : load("res://assets/art/npc/mia/mia3.png"),
		"base_msg" : "내가 관상을 볼줄 알어.... 넌 글렀어 임마...",
	},
	0x9001:{
		"code" : 0x9001,
		"name" : "장로스탄",
		"description" : "커닝시티 갤주",
		"type" : "quest",
		"image" : load("res://assets/art/npc/stan/stan2.png"),
		"base_msg" : "내가 관상을 볼줄 알어.... 넌 글렀어 임마...",
	},
	0x9002:{
		"code" : 0x9002,
		"name" : "카일",
		"description" : "헤네시스 갤주",
		"type" : "quest",
		"image" : load("res://assets/art/npc/kale/kale.png"),
		"base_msg" : "김민홍!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!",
	},
	0x9003:{
		"code" : 0x9003,
		"name" : "알렉스",
		"description" : "장로스탄 아들ㅋㅋ",
		"type" : "quest",
		"image" : load("res://assets/art/npc/alex/alex.png"),
		"base_msg" : "장로스탄 아들입니다. 어쩌라고요. ",
	},
	0x9004:{
		"code" : 0x9004,
		"name" : "주호",
		"description" : "계림맨",
		"type" : "quest",
		"image" : load("res://assets/art/npc/juho/juho.png"),
		"base_msg" : "?ㅗㅗㅗㅗㅗㅗㅗㅗㅗㅗㅗㅗㅗ",
	},
	0x9005:{
		"code" : 0x9005,
		"name" : "무야호",
		"description" : "그만큼 재밋다는 거지",
		"type" : "quest",
		"image" : load("res://assets/art/npc/muyaho/muyaho.png"),
		"base_msg" : "우리가 많이 보죠 ㅋㅋ",
	},
	0x9006:{
		"code" : 0x9006,
		"name" : "아메리칸",
		"description" : "유학파",
		"type" : "quest",
		"image" : load("res://assets/art/npc/american/american.png"),
		"base_msg" : "헬조선 잘못 온듯 ㅈㅈ",
	}
}

# 판매 물품
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
