# NemoMohum

### How to play

I : 인벤토리 열기 
K : 스킬창 열기 
U : 스탯창 열기 
J : 퀘스트창 열기 

Ctrl : 공격 
A, B, C, D : 퀵슬롯키 
방향키 : 이동
Alt : 점프

### Quest 
```
	QuestID : {
		"quest_code" : QuestID, 
		"quest_name" : "msg",
		"quest_supplies" : { ##퀘스트 시작시 받는 물품
			"item" : {
				"equipment" : [
				],
				"etc" : [
					
				]
			},
			"state" : {
				"coin" : int,
				"current_exp" : int,
			}
		},
		"quest_goal" : {
			"item" : [
				{
					"code" : int:ItemCode,
					"numberof" : int,
					"player_count" : int,
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
				"coin" : int, 
				"current_exp" : int, 
			},
			"item" : {
				"consumption" : [
					{
						"code" : QuestID, 
						"numberof" : int,
						"type" : "consumption",
					},
					{
						"code" : 0xB003,
						"numberof" : 2,
						"type" : "consumption",
					}
				],
			}
		},
		"quest_not_started_msg" : [
            "msg", "msg..."
		],
		"quest_progress_msg" : ["msg", "msg..."],
		"quest_complete_msg" : ["msg", "msg..."],
		"quest_before_summary_msg" : ""msg", 
		"quest_summary_msg" : "msg",
		"npc_code" : NpcCode:int,
		"condition" : {
			"level" : int, 
			"quest_list" : [int:QuestID, int:QuestID],
		},
		"quest_state" : NOT_START, #or PROGRSS or COMPLETE
	},
```

### NpcList
```
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
}
```

### NpcShop
```
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

```

### Enemy
```
var EnemyList = {
	EnemyID : {
		"enemy_code" : EnemyID,
		"enemy_name" : String:name,
		"state" : {
			"attack" : int,
			"def" : int, 
			"max_hp" : int,
			"current_hp" : int,
			"speed" : int,
			"level" : int,
		},
		"spoil" : {
			"coin" : int,
			"exp" : int,
			"item" : [
				{
					"code" : int:ItemCode,
					"numberof" : 1,
					"percentage" : 30, 
				},
			]
		}
	},
}
```
