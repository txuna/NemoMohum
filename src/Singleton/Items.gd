extends Node

var Items = {
	0xA000:{
		"item_name" : "기본칼",
		"item_description" : "전설의 칼인듯함",
		"code" : 0xA000, 
		"item_icon" : "",
		"item_image" : "res://assets/art/weapon/sword/basic_sword.png",
		"item_scene" : preload("res://src/Weapon/Sword/BasicSword.tscn"),
		"affect_player" : true,
		"effect" : {
			"min_attack" : 1,
			"max_attack" : 3,
		},
		"type" : "equipment",
		"detail_type" : "weapon",
		"weapon_type" : "Sword",
	},
}
