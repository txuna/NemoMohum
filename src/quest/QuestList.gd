class_name QuestList

const NOT_START = 0
const PROGRESS = 1
const CAN_COMPLETE = 2
const WAS_COMPLETE = 3 #이미 완료된거

var QuestList = {
	0xD000 : {
		"quest_code" : 0xD000, 
		"quest_name" : "환영해 뉴비!",
		"quest_supplies" : { ##퀘스트 시작시 받는 물품
			"item" : {
				"consumption" : [
					
				],
				"etc" : [
					
				]
			},
			"state" : {
				"coin" : 100,
				"current_exp" : 0,
			}
		},
		"quest_goal" : {
			"item" : [
				{
					"code" : 0xC001,
					"numberof" : 1,
					"player_count" : 0, #플레이어의 진행상태
				}
			],
			"enemy" : [
			],
			# 특장 NPC에게 대화걸기
			"talk_to" : [
				# 성공여부는 false and true
			]
		},
		"quest_reward" : {
			"state" : {
				"coin" : 300, 
				"current_exp" : 30, 
			},
			"item" : {
				"consumption" : [
					{
						"code" : 0xB000, 
						"numberof" : 2,
						"type" : "consumption",
					},
					{
						"code" : 0xB001,
						"numberof" : 2,
						"type" : "consumption",
					}
				]
			}
		},
		"quest_not_started_msg" : ["관상을 보아하니 뉴비구나!", ".....", "왜 말이 없어 ㅈ밥이야?", ".....", "ㅈ밥이 아님을 증명해봐!", 
									"저기 보이는 지도 끝의 바다로 향해 이섬을 탈출해봐", "어떻게 하냐고?", 
									"게임의 기본 구조를 알려줄게", "공격은 Ctrl, 점프는 Alt, 방향키로 이동하고 인벤토리는 I, 퀘스트는 J, 스탯은 U, 스킬은 K", 
									"이제 알아서 생존하세용", "어떻게 생존하냐고? 궁금한거 많으시네요ㅎㅎ", "주민들의 퀘스를 도우면서 생존해봐!",
									".....", "뭐? 시범으로 퀘스트를 하나 달라고?", "돈을 줄테니 개구리 다리 1개 사오면 그때 퀘스트 생객해볼게"],
									
		"quest_progress_msg" : ["아직 못구함?" ,"실력 ㅆㅎㅌㅊ"],
		"quest_complete_msg" : ["ㄳㄳ", "보상으로 약간의 돈이랑 경험치, 물약을 줄게", "다시 나에게 말을 걸어줘!"],
		"quest_summary_msg" : "현지인으로 보이는 이 친구는 난데없이 돈을 주고 개구리 다리를 사오라는데... 어 잠깐? 돈이 모자라는데(개구리 다리는 상점에서 구매가 가능합니다. 상점은 미아에게!)",
		"npc_code" : 0x9001,
		"condition" : {
			"level" : 1, 
			"quest_list" : [],
		},
		"quest_state" : NOT_START, #or PROGRSS or COMPLETE
	},
	0xD001 : {
		"quest_code" : 0xD001, 
		"quest_name" : "게임세계 이해하기",
		"quest_supplies" : { ##퀘스트 시작시 받는 물품
			"item" : {
				"equipment" : [
					{
						"code" : 0xA001, 
						"numberof" : 1,
						"type" : "equipment",
					}
				],
				"etc" : [
					
				]
			},
			"state" : {
				"coin" : 0,
				"current_exp" : 0,
			}
		},
		"quest_goal" : {
			"item" : [
			],
			"enemy" : [
				{
					"code" : 0xF007,
					"numberof" : 5,
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
				"current_exp" : 50, 
			},
			"item" : {
				"consumption" : [
					{
						"code" : 0xB000, 
						"numberof" : 2,
						"type" : "consumption",
					},
					{
						"code" : 0xB001,
						"numberof" : 2,
						"type" : "consumption",
					}
				]
			}
		},
		"quest_not_started_msg" : ["오 다시 말 걸어주셨네요 ㅎㅇㅎㅇ", "이제 상점 이용법도 알고 게임 조작법도 아니까 마을의 오른쪽으로 쭉 가면 포탈이 나온다네",
									"포탈을 타고 나가면 기사단의 검병들이 미쳐 날뛰고 있을 거라네", "내가 준 무기로 5마리만 잡아와줘!", "정말 나쁜놈들이야"],
		"quest_progress_msg" : ["형편없는 실력이구나!" ,"실망하지 말게 나는 자네를 처음부터 믿고 있지 않았다구"],
		"quest_complete_msg" : ["오!! 믿고있었다구", "잘했다네, 근데 피가 없구만 자네 허허, 자 받게 물약과 경험치라네", "그리고 다시 나에게 말을 걸어줘!"],
		"quest_summary_msg" : "현지인으로 보이는 할아버지는 맵끝의 오른쪽에 존재하는 포탈을 타고 가면 기사단의 검병이 존재한다고 한다고 들었던것 같은데... 씨 어케 잡지",
		"npc_code" : 0x9001,
		"condition" : {
			"level" : 1, 
			"quest_list" : [0xD000],
		},
		"quest_state" : NOT_START, #or PROGRSS or COMPLETE
	},
}

var NpcQuest = {
	0x9001 : [0xD000, 0xD001], #stan
	0x9002 : [], #kale
	0x9003 : [], #alex
	0x9004 : [], #juho
	0x9005 : [], #muyaho
	0x9006 : [], #american
}
