extends Request
class_name FriendRequest

const save_extension_name="datsky_relationships"

const dialog = preload("uid://rev28o3xghn")#"res://Assets/Dialog/FriendRequestDialog.dialogue"
const quest_icon = preload("uid://cbxclkdd6tdx8")#"res://Assets/Images/SVG/Friends.svg"

@export var origin_relationship_need : HabitantNeed
@export var habitant : Habitant
@export var befriend_account : RelationshipAccount

static func create(room : Residence, _habitant: Habitant, original_need:HabitantNeed, friend: RelationshipAccount) -> FriendRequest:
	var req = FriendRequest.new()
	req.type=RequestFulfillmentType.DIALOG
	req.priority=4
	req.title="I want to befriend someone"
	req.origin=room
	
	req.habitant=_habitant
	req.origin_relationship_need = original_need
	req.befriend_account=friend
	print("I exist")
	return req

func consume_talk_action(action:TalkAction):
	if action.is_consumed():
		return
	action.consume()
	
	if befriend_account.type==RelationshipAccount.AccountType.HABITANT:
		var friend = befriend_account.origin
		action.display_node.start_habitant_dialog(dialog,[{"friend":friend,"request":self}])
		
func consume_quest_icon_request(action:ValueRequestAction):
	if action.is_consumed():
		return
	
	action.consume()
	action.value=quest_icon

func befriend():
	var relationship_system : RelationshipSaveData = SaveSystem.save.save_extension.get(save_extension_name,"null")
	if relationship_system:
		relationship_system.befriend_accounts(origin_relationship_need.relationship_account,befriend_account.id)
	fulfill()

func _accept():
	print("important stuff")
	habitant.began_request_talk.connect(consume_talk_action)
	habitant.requested_quest_icon.connect(consume_quest_icon_request)
