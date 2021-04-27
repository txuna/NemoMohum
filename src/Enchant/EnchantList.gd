class_name EnchantList

#cumulative_percent는 누적 확률이다. 0~100까지 랜덤 수에서 0~10은, 10~100 이렇게 전리품 뽑기처럼 
#최종 누적 확률 100이 되는것이 마지막으로 무조건 존재해야함. 

var upgrade_percent = {
	"D" : {
		"plus_option_percent" : 1, 
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
		"plus_option_percent" : 5, 
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


var rank_list = {
	0x3000 : "D",
	0x3001 : "D",
}

### code : enchant code 0x1000~ player state upgrade
### code : ehcnat code 0x200 0~ player inherent skill
var state_enchant_list = {
	0x1000 : {
		"code" : 0x1000, 
		"name" : "최대 공격력 1단계",
		"effect" : {
			"max_attack" :10, 
		},
	},
	0x1002 : {
		"code" : 0x1002, 
		"name" : "최대 공격력 2단계",
		"effect" : {
			"max_attack" :20, 
		},
	},
}

var skill_enchant_list = {
	0x2000 : {
		
	},
}

func get_rank(code:int):
	return rank_list[code]

func get_upgrade_percent(rank:String):
	return upgrade_percent[rank]

func get_enchant(code:int):
	if code >= 0x1000 and code <= 0x1FFF:
		return state_enchant_list[code]
		
	elif code >= 0x2000 and code <= 0x2FFF:
		return skill_enchant_list[code]
