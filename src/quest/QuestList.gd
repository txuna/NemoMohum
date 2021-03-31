class_name QuestList

const NOT_START = 0
const PROGRESS = 1
const CAN_COMPLETE = 2
const WAS_COMPLETE = 3 #이미 완료된거

var QuestList = {
	0xD000 : {
		"quest_code" : 0xD000, 
		"quest_name" : "죽 쑤기",
		"quest_goal" : {
			"item" : [
				{
					"code" : 0xC000,
					"numberof" : 10,
					"player_count" : 0, #플레이어의 진행상태
				}
			],
			"enemy" : [
				{
					"code" : 0xF002,
					"numberof" : 10,
					"player_count" : 0,
				}
			],
			# 특장 NPC에게 대화걸기
			"talk_to" : [
				# 성공여부는 false and true
			]
		},
		"quest_reward" : {
			"state" : {
				"coin" : 300, 
				"current_exp" : 2000, 
			},
			"item" : {
				"consumption" : [
					{
						"item_code" : 0xB000, 
						"numberof" : 2,
					},
					{
						"item_code" : 0xB001,
						"numberof" : 3,
					}
				]
			}
		},
		"quest_not_started_msg" : ["배고프다....", "너 누구냐....?", "나 나뭇잎 10개만....", "구해다 주면 보상 주겠다...."],
		"quest_progress_msg" : ["아직 못구함?" ,"실력 ㅆㅎㅌㅊ"],
		"quest_complete_msg" : ["ㄳㄳ"],
		"quest_summary_msg" : "배가 고픈듯하다. 죽을 쑤기 위한 나뭇잎 10개를 구해다 주자. 근데 꼭 구해다 줘야하는 걸까. 그들이 과연 배고픔을 알까요?",
		"npc_code" : 0x9001,
		"condition" : {
			"level" : 0, 
			"quest_list" : [],
		},
		"quest_state" : NOT_START, #or PROGRSS or COMPLETE
	},
	0xD001 : {
		"quest_code" : 0xD001, 
		"quest_name" : "빨간포션 공짜로 매입",
		"quest_goal" : {
			"item" : [
				{
					"code" : 0xB000,
					"numberof" : 10,
					"player_count" : 0, #플레이어의 진행상태
				}
			],
		},
		"quest_reward" : {
			"state" : {
				"coin" : 300, 
				"current_exp" : 2000, 
			},
			"item" : {
				"consumption" : [
					{
						"item_code" : 0xB000, 
						"numberof" : 2,
					},
					{
						"item_code" : 0xB001,
						"numberof" : 3,
					}
				]
			}
		},
		"quest_not_started_msg" : ["빨간포션 사요", "? ㅎㅇㅎㅇㅎ 10개만요ㅋㅋ"],
		"quest_progress_msg" : ["아직 못구함?" ,"실력 ㅆㅎㅌㅊ"],
		"quest_complete_msg" : ["ㄳㄳ"],
		"quest_summary_msg" : "빨간포션이 급히 필요해보이는 듯하다 얼른 10개를 구해다 주자",
		"npc_code" : 0x9001,
		"condition" : {
			"level" : 0, 
			"quest_list" : [],
		},
		"quest_state" : NOT_START, #or PROGRSS or COMPLETE
	}
}

var NpcQuest = {
	0x9001 : [0xD000, 0xD001],
}
