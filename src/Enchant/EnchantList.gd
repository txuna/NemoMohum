class_name EnchantList

#cumulative_percent는 누적 확률이다. 0~100까지 랜덤 수에서 0~10은, 10~100 이렇게 전리품 뽑기처럼 
#최종 누적 확률 100이 되는것이 마지막으로 무조건 존재해야함. 

var upgrade_percent = {
	"D" : {
		"plus_option_percent" : 5, 
		"option_percent" : [
			{
				"code" : 0x1001,
				"cumulative_percent" : 10,
			},
			{
				"code" : 0x1000,
				"cumulative_percent" : 100,
			},
		],
	},
	"C" : {
		"plus_option_percent" : 10, 
		"option_percent" : [
			{
				"code" : 0x1001,
				"cumulative_percent" : 20,
			},
			{
				"code" : 0x1000,
				"cumulative_percent" : 100,
			},
		],
	},
	"B" : {
		"plus_option_percent" : 10, 
	},
	"A" : {
		"plus_option_percent" : 25, 
	},
	"S" : {
		"plus_option_percent" : 50, 
	},
}

var soulstone_to_skill = {
	0x3000 : 0x2000, 
	0x3001 : 0x2001,
}

var rank_list = {
	0x3000 : "D",
	0x3001 : "D",
}

### code : enchant code 0x1000~ player state upgrade
### code : ehcnat code 0x200 0~ player inherent skill
var state_enchant_list = {
	0x1000 : {
		"code" : 0x1000, 
		"name" : "최대 공격력 1단계 증가",
		"effect" : {
			"max_attack" :10, 
		},
	},
	0x1001 : {
		"code" : 0x1001, 
		"name" : "최대 공격력 2단계 증가",
		"effect" : {
			"max_attack" :20, 
		},
	},
}

# 공격 대상에게 effect를 전한다. 
var skill_enchant_list = {
	0x2000 : {
		"code" : 0x2000,
		"name" : "적 공격시 5초간 이동속도 30% 감소",
		"option" : {
			"is_buff" : true,
			"time" : 5,  
		},
		"percent" : true,
		"effect" : {
			"speed" : -30,
		},
	},
	0x2001 : {
		"code" : 0x2001,
		"name" : "적 공격시 7초간 방어력 50% 감소",
		"option" : {
			"is_buff" : true,
			"time" : 7,  
		},
		"percent" : true,
		"effect" : {
			"def" : 50,
		},
	},
	0x2002 : {
		"code" : 0x2002,
		"name" : "적 공격시 추가 데미지 10",
		"option" : {
			"is_buff" : false, #false로 즉발형 스킬
			"time" : 0,  
		},
		"percent" : false,
		"effect" : {
			"current_hp" : 20,
		},
	},
}

func get_soulstone_to_skill(code:int):
	return soulstone_to_skill[code]

func get_rank(code:int):
	return rank_list[code]


func get_upgrade_percent(rank:String):
	return upgrade_percent[rank]

func get_enchant(code:int):
	if code >= 0x1000 and code <= 0x1FFF:
		return state_enchant_list[code]
		
	elif code >= 0x2000 and code <= 0x2FFF:
		return skill_enchant_list[code]
