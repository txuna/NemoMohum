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
					"item_code" : 0xC000,
					"numberof" : 10,
				}
			],
			"kill_enemy" : [
				{
					"enemy_code" : 0xF000,
					"numberof" : 10,
				}
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
		"basic_msg" : "날씨 좋다~~~~~~",
		"quest_not_started_msg" : "배가고프다 나뭇잎좀 구해다줘",
		"quest_progress_msg" : "아직 못구함?",
		"quest_complete_msg" : "ㄳㄳ",
		"quest_summary_msg" : "배가 고픈듯하다. 죽을 쑤기 위한 나뭇잎 10개를 구해다 주자.",
		"npc_code" : 0x9001,
		"condition" : {
			"level" : 0, 
			"quest_list" : [],
		},
		"quest_state" : NOT_START, #or PROGRSS or COMPLETE
	}
}

var NpcQuest = {
	0x9001 : [0xD000],
}
