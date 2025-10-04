extends Request
class_name FoodRequest

const hungry_dialog = preload("uid://c4mi3dqi1bnva")#"res://Assets/Dialog/FoodRequestDialog.dialogue"
const quest_icon = preload("uid://du02b0g6oq1ng")#"res://Assets/Images/PNG/Plate.png"

var habitant : Habitant


func _init(room : Residence, habitant: Habitant) -> void:
	type=RequestFulfillmentType.GIFT
	priority=3
	title="I want food"
	origin=room
	
	self.habitant=habitant

func consume_talk_action(action:TalkAction):
	if action.is_consumed():
		return
	action.consume()
	action.display_node.start_habitant_dialog(hungry_dialog)

func consume_quest_icon_request(action:ValueRequestAction):
	if action.is_consumed():
		return
	action.consume()
	action.value=quest_icon

func accept():
	habitant.began_talk.connect(consume_talk_action)
	habitant.requested_quest_icon.connect(consume_quest_icon_request)
