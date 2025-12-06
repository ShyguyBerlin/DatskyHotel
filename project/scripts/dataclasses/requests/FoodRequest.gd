extends Request
class_name FoodRequest

const hungry_dialog = preload("uid://c4mi3dqi1bnva")#"res://Assets/Dialog/FoodRequestDialog.dialogue"
const fed_dialog = preload("uid://bbvvsvg4m1t77")#"res://Assets/Dialog/FoodRequestFulfilledDialog.dialogue"
const quest_icon = preload("uid://du02b0g6oq1ng")#"res://Assets/Images/PNG/Plate.png"

@export var habitant : Habitant
@export var origin_hunger : HabitantNeed

static func create(room : Residence, _habitant: Habitant, original_need:HabitantNeed) -> FoodRequest:
	var req = FoodRequest.new()
	req.type=RequestFulfillmentType.GIFT
	req.priority=3
	req.title="I want food"
	req.origin=room
	
	req.origin_hunger = original_need
	req.habitant = _habitant
	return req

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

func consume_gift_action(action:GiftAction):
	if action.is_consumed():
		return
	var item = action.get_item()
	if item is FoodItem:
		action.consume()
		await action.display_node.start_habitant_dialog(fed_dialog,[{"gift":item}])
		if randf()<0.2:
			action.reward_item("bretzel")
		
		if randf()<0.05:
			action.reward_money(randf()*27+3)
		else:
			action.reward_money(randf()*2+1)
		action.display_node.draw_quest_icon.call_deferred()
		fulfill()

func accept():
	print("important stuff")
	habitant.began_talk.connect(consume_talk_action)
	habitant.requested_quest_icon.connect(consume_quest_icon_request)
	habitant.recieved_gift.connect(consume_gift_action)
