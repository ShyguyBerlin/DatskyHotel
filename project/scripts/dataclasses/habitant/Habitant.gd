extends Resource
class_name Habitant

@export var name = "Alice"
@export var residence : Residence
@export var needs : Array[HabitantNeed]
@export var assets : Array[HabitantProperty]

@export var body_color : Color
@export var bodytype : HabitantOutfit.BodyType
@export var outfit : HabitantOutfit

signal began_talk(talk:TalkAction)
signal recieved_gift(gift:GiftAction)
signal requested_quest_icon(action:ValueRequestAction)

const std_dialog_path="res://Assets/Dialog/HabitantDialog.dialogue"
const std_dialog=preload(std_dialog_path)

func process(delta : float):
	for i in needs:
		i.process(delta)

func generate_request(residence:Residence) -> Array[Request]:
	var arr : Array[Request] = []
	for n in needs:
		arr.append_array(n.generate_request(residence))
	return arr

func add_need(need : HabitantNeed):
	needs.append(need)
	need.habitant=self

func recieve_gift(obj):
	var gift_action :GiftAction=GiftAction.new()
	recieved_gift.emit(gift_action)
	if gift_action.is_consumed():
		return

func consume_talk_action(action : TalkAction):
	began_talk.emit(action)
	if action.is_consumed():
		return
	action.display_node.start_habitant_dialog(std_dialog)
	action.consume()

func consume_quest_icon_request(action : ValueRequestAction) -> void:
	requested_quest_icon.emit(action)
