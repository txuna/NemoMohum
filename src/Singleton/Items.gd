extends Node

var Items = {
	0xA000:{
		"item_name" : "기본칼",
		"item_description" : "전설의 칼인듯함",
		"code" : 0xA000, 
		"item_image" : load("res://assets/art/weapon/sword/basic_sword.png"),
		"item_scene" : preload("res://src/Weapon/Sword/BasicSword.tscn"),
		"affect_player" : true,
		"effect" : {
			"min_attack" : 1,
			"max_attack" : 3,
		},
		"type" : "equipment",
		"detail_type" : "weapon",
		"weapon_type" : "Sword",
		"buy" : 50,
		"sell" : 25,
		"attack_delay" : 0.35,
	},
	0xA001:{
		"item_name" : "나뭇가지",
		"item_description" : "이장님댁 감나무 나뭇가지이다.",
		"code" : 0xA001, 
		"item_image" : load("res://assets/art/weapon/sword/branch_sword.png"),
		"item_scene" : preload("res://src/Weapon/Sword/BranchSword.tscn"),
		"affect_player" : true,
		"effect" : {
			"min_attack" : 5,
			"max_attack" : 12,
		},
		"type" : "equipment",
		"detail_type" : "weapon",
		"weapon_type" : "Sword",
		"buy" : 50,
		"sell" : 25,
		"attack_delay" : 0.43,
	},
	0xA002:{
		"item_name" : "기본 활",
		"item_description" : "가장 싼 나무 활.",
		"code" : 0xA002, 
		"item_image" : load("res://assets/art/weapon/bow/basic_bow_icon.png"),
		"item_scene" : preload("res://src/Weapon/Bow/BasicBow.tscn"),
		"affect_player" : true,
		"effect" : {
			"min_attack" : 1,
			"max_attack" : 3,
		},
		"type" : "equipment",
		"detail_type" : "weapon",
		"weapon_type" : "Bow",
		"buy" : 50,
		"sell" : 25,
		"attack_delay" : 0.5,
	},
	0xA003:{
		"item_name" : "기본 총",
		"item_description" : "가장 싼 기본 총",
		"code" : 0xA003, 
		"item_icon" : "",
		"item_image" : load("res://assets/art/weapon/gun/basic_gun.png"),
		"item_scene" : preload("res://src/Weapon/Gun/BasicGun.tscn"),
		"affect_player" : true,
		"effect" : {
			"min_attack" : 3,
			"max_attack" : 7,
		},
		"type" : "equipment",
		"detail_type" : "weapon",
		"weapon_type" : "Gun",
		"buy" : 50,
		"sell" : 25,
		"attack_delay" : 0.25,
	},
	0xB000 : {
		"code" : 0xB000, 
		"item_name" : '빨간포션',
		"affect_player" : true,
		"effect" : {
			"current_hp" : 100,
		},
		"type" : "consumption",
		"item_image" : load("res://assets/art/spoil/consumption/red_potion.png"),	
		"item_description" : "배고플때 먹는 포션이다.\n체력을 100올려준다.",
		"buy" : 50,
		"sell" : 25,
	},
	0xB001 : {
		"code" : 0xB001, 
		"item_name" : '파란포션',
		"affect_player" : true,
		"effect" : {
			"current_mp" : 100,
		},
		"type" : "consumption",
		"item_image" : load("res://assets/art/spoil/consumption/blue_potion.png"),	
		"item_description" : "목마를때 마시는 포션이다.\n마나를 100올려준다.",
		"buy" : 50,
		"sell" : 25,
	},
	0xC000 : {
		"code" : 0xC000, 
		"item_name" : '장미 잎',
		"affect_player" : false,
		"type" : "etc",
		"item_image" : load("res://assets/art/spoil/etc/leap.png"),	
		"item_description" : "장미 잎이다. 고급 약재로 쓰인다.",
		"buy" : 10,
		"sell" : 5,
	}
}
