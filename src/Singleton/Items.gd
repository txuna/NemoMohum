extends Node

var Items = {
	0xA000:{
		"item_name" : "철검",
		"item_description" : "철로 만든 검이 맞을까...?",
		"code" : 0xA000, 
		"item_image" : load("res://assets/art/weapon/sword/iron_sword.png"),
		"item_scene" : preload("res://src/Weapon/Sword/BasicSword.tscn"),
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
		"is_quest_item" : false,
	},
	0xA001:{
		"item_name" : "나뭇가지",
		"item_description" : "이장님댁 감나무 나뭇가지이다.",
		"code" : 0xA001, 
		"item_image" : load("res://assets/art/weapon/sword/basic_branch1.png"),
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
		"is_quest_item" : false,
	},
	0xA002:{
		"item_name" : "기본 활",
		"item_description" : "가장 싼 나무 활.",
		"code" : 0xA002, 
		"item_image" : load("res://assets/art/weapon/bow/basic_bow1_icon.png"),
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
		"is_quest_item" : false,
	},
	0xA003:{
		"item_name" : "기본 권총",
		"item_description" : "가장 싼 기본 권총",
		"code" : 0xA003, 
		"item_icon" : "",
		"item_image" : load("res://assets/art/weapon/gun/basic_gun1.png"),
		"item_scene" : preload("res://src/Weapon/Gun/BasicGun.tscn"),
		"affect_player" : true,
		"effect" : {
			"min_attack" : 12,
			"max_attack" : 18,
		},
		"type" : "equipment",
		"detail_type" : "weapon",
		"weapon_type" : "Gun",
		"buy" : 50,
		"sell" : 25,
		"attack_delay" : 0.35,
		"is_quest_item" : false,
	},
	0xA004:{
		"item_name" : "기본 라이플",
		"item_description" : "가장 싼 기본 라이플",
		"code" : 0xA004, 
		"item_icon" : "",
		"item_image" : load("res://assets/art/weapon/gun/riple1.png"),
		"item_scene" : preload("res://src/Weapon/Gun/BasicRifle.tscn"),
		"affect_player" : true,
		"effect" : {
			"min_attack" : 5,
			"max_attack" : 11,
		},
		"type" : "equipment",
		"detail_type" : "weapon",
		"weapon_type" : "Gun",
		"buy" : 50,
		"sell" : 25,
		"attack_delay" : 0.05,
		"is_quest_item" : false,
	},
	0xA005:{
		"item_name" : "나무 스틱",
		"item_description" : "도장에서 훔쳐온 나무 스틱",
		"code" : 0xA005, 
		"item_icon" : "",
		"item_image" : load("res://assets/art/weapon/sword/stick.png"),
		"item_scene" : preload("res://src/Weapon/Sword/Stick.tscn"),
		"affect_player" : true,
		"effect" : {
			"min_attack" : 9,
			"max_attack" : 15,
		},
		"type" : "equipment",
		"detail_type" : "weapon",
		"weapon_type" : "Sword",
		"buy" : 50,
		"sell" : 25,
		"attack_delay" : 0.41,
		"is_quest_item" : false,
	},
	0xA030:{
		"item_name" : "기본 갑옷",
		"item_description" : "훈련장에서 입는 연습용 갑옷",
		"code" : 0xA030, 
		"item_icon" : "",
		"item_image" : load("res://assets/art/armor/shirt/basic_shirt/basic_shirt.png"),
		"item_scene" : preload("res://src/Armor/Shirt/BasicShirt.tscn"),
		"affect_player" : true,
		"effect" : {
			"def" : 200,
		},
		"type" : "equipment",
		"detail_type" : "armor",
		"armor_type" : "shirt",
		"buy" : 50,
		"sell" : 25,
		"attack_delay" : 0.41,
		"is_quest_item" : false,
	},
	0xA031:{
		"item_name" : "기본 모자",
		"item_description" : "훈련장에서 입는 기본 모자.\n슬라임의 형태를 띄고 있다.",
		"code" : 0xA031, 
		"item_icon" : "",
		"item_image" : load("res://assets/art/armor/hat/basic_hat.png"),
		"item_scene" : preload("res://src/Armor/Hat/BasicHat.tscn"),
		"affect_player" : true,
		"effect" : {
			"def" : 300,
			"max_hp" : 1000,
		},
		"type" : "equipment",
		"detail_type" : "armor",
		"armor_type" : "hat",
		"buy" : 50,
		"sell" : 25,
		"attack_delay" : 0.41,
		"is_quest_item" : false,
	},
	0xB000 : {
		"code" : 0xB000, 
		"item_name" : '빨간포션',
		"affect_player" : true,
		"effect" : {
			"current_hp" : 100,
		},
		"type" : "consumption",
		"detail_type" : "hp",
		"item_image" : load("res://assets/art/spoil/consumption/red_potion.png"),	
		"item_description" : "배고플때 먹는 포션이다.\n체력을 100올려준다.",
		"buy" : 50,
		"sell" : 25,
		"icon" : load("res://assets/art/icon/red_potion_icon.png"),
		"is_quest_item" : false,
	},
	0xB001 : {
		"code" : 0xB001, 
		"item_name" : '파란포션',
		"affect_player" : true,
		"effect" : {
			"current_mp" : 100,
		},
		"type" : "consumption",
		"detail_type" : "mp",
		"item_image" : load("res://assets/art/spoil/consumption/blue_potion.png"),	
		"item_description" : "목마를때 마시는 포션이다.\n마나를 100올려준다.",
		"buy" : 50,
		"sell" : 25,
		"icon" : load("res://assets/art/icon/blue_potion_icon.png"),
		"is_quest_item" : false,
	},
	0xC000 : {
		"code" : 0xC000, 
		"item_name" : '개구리 잎',
		"affect_player" : false,
		"type" : "etc",
		"detail_type" : "spoil",
		"item_image" : load("res://assets/art/spoil/etc/leaf.png"),	
		"item_description" : "장미 잎이다. 고급 약재로 쓰인다.",
		"buy" : 10,
		"sell" : 5,
		"is_quest_item" : false,
	},
	0xC001 : {
		"code" : 0xC001, 
		"item_name" : '개구리 다리',
		"affect_player" : false,
		"type" : "etc",
		"detail_type" : "spoil",
		"item_image" : load("res://assets/art/spoil/etc/frog_leg.png"),	
		"item_description" : "개구리 다리다. 구워먹으면 맛있다.",
		"buy" : 10,
		"sell" : 5,
		"is_quest_item" : false,
	},
	0xC002 : {
		"code" : 0xC002, 
		"item_name" : '토끼 고기',
		"affect_player" : false,
		"type" : "etc",
		"detail_type" : "spoil",
		"item_image" : load("res://assets/art/spoil/etc/hare_meat.png"),	
		"item_description" : "무장봉 토끼 고기다. 질기지만 맛있다.",
		"buy" : 10,
		"sell" : 5,
		"is_quest_item" : false,
	},
	0xC003 : {
		"code" : 0xC003, 
		"item_name" : '도토리',
		"affect_player" : false,
		"type" : "etc",
		"detail_type" : "spoil",
		"item_image" : load("res://assets/art/spoil/etc/acorn.png"),	
		"item_description" : "다람쥐가 먹다 남긴 도토리다.\n나는 도토리묵을 좋아한다.",
		"buy" : 10,
		"sell" : 5,
		"is_quest_item" : true,
	},
	0xC004 : {
		"code" : 0xC004, 
		"item_name" : '멧돼지의 뿔',
		"affect_player" : false,
		"type" : "etc",
		"detail_type" : "spoil",
		"item_image" : load("res://assets/art/spoil/etc/horn.png"),	
		"item_description" : "야생 멧돼지의 뿔이다.\n집안의 가보로 쓰인다.",
		"buy" : 10,
		"sell" : 5,
		"is_quest_item" : false,
	},
	0xC005 : {
		"code" : 0xC005, 
		"item_name" : '뱀 가죽',
		"affect_player" : false,
		"type" : "etc",
		"detail_type" : "spoil",
		"item_image" : load("res://assets/art/spoil/etc/Snakeskin.png"),	
		"item_description" : "겨울잠을 끝마친 뱀의 가죽이다.\n고기를 가죽으로 감싸서\n불구덩이에 넣고 굽자.",
		"buy" : 10,
		"sell" : 5,
		"is_quest_item" : false,
	},
	0x3000 : {
		"code" : 0x3000, 
		"item_name" : '얼어붙은 영원석[D]',
		"affect_player" : false,
		"type" : "etc",
		"detail_type" : "soulstone",
		"item_image" : load("res://assets/art/spoil/etc/soul_stone.png"),	
		"item_description" : "얼어붙은 영원석이다...\n신비함 힘을 가지고 있다....",
		"buy" : 10,
		"sell" : 5,
		"is_quest_item" : false,
	}
}

func is_quest_item(item_code:int):
	if Items[item_code]["is_quest_item"]:
		return true
	else:
		return false
