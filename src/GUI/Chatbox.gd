extends CanvasLayer

const NOT_START = 0
const PROGRESS = 1
const CAN_COMPLETE = 2
const WAS_COMPLETE = 3 #이미 완료된거
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# 진행할 수 있는거 + 진행중인거 + 완료할 수 있는거
# 레벨과 사전퀘스트 달성 여부를 보고 적절 판단 -> WAS_COMPLETE가 아닌거 표시
func load_possible_quest(npc_code):
	pass



func exit_chatbox():
	queue_free()
	return
