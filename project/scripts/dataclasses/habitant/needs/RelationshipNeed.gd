extends HabitantNeed

const DEBUG = false  # Set to true to enable debug output

const save_extension_name="datsky_relationships"

var relationship_global_data:RelationshipSaveData=null
@export var relationship_account:int=-1 # This is only an ID because of cyclic dependencies

const RELATIONSHIP_DIALOG = preload("uid://v71rq2gyta76")

func load_relationship_global_data():
	if relationship_global_data:
		return
	
	# Use centralized access that works during and after loading
	var save_ext = SaveSystem.get_save_extension(save_extension_name)
	if save_ext:
		relationship_global_data = save_ext
	else:
		# Create new if doesn't exist
		relationship_global_data = RelationshipSaveData.create()
		SaveSystem.save.save_extension[save_extension_name] = relationship_global_data
	
	if DEBUG:
		print("I am Relationshipneed again, I loaded relationship_global_data, it is ",relationship_global_data)
		print("  _accounts dict: ", relationship_global_data._accounts)
		print("  _accounts keys: ", relationship_global_data._accounts.keys())
		print("  _account_id_counter: ", relationship_global_data._account_id_counter)

func _init() -> void:
	if DEBUG:
		print("So, I am a Relationshipneed and I am init()..ing, I want to access the SaveSystem Node and it is ready: ",SaveSystem.is_node_ready())

# Should only be called on habitant deletion
func unbind_habitant() -> void:
	load_relationship_global_data()
	habitant.recieved_gift.disconnect(consume_gift_action)
	habitant.began_talk.disconnect(consume_talk_action)
	relationship_global_data.delete_account(relationship_account)

# Should only be called on habitant/need creation
func bind_habitant() -> void:
	load_relationship_global_data()
	# Disconnect if already connected to avoid duplicates
	if habitant.recieved_gift.is_connected(consume_gift_action):
		habitant.recieved_gift.disconnect(consume_gift_action)
	if habitant.began_talk.is_connected(consume_talk_action):
		habitant.began_talk.disconnect(consume_talk_action)
	# Connect signals
	habitant.recieved_gift.connect(consume_gift_action)
	habitant.began_talk.connect(consume_talk_action)
	# Only create account if it doesn't exist (prevents duplicate on load)
	if relationship_account == -1:
		relationship_account=relationship_global_data.create_habitant_account(habitant).id
	else:
		pass

func consume_gift_action(action:GiftAction):
	pass

func consume_talk_action(action:TalkAction):
	if action.is_consumed():
		return
	action.consume()
	var friend = null
	var affiliations = relationship_global_data.view_account(relationship_account)
	var friend_affiliation = null
	if len(affiliations)>0:
		friend_affiliation = Utility.weighted_select_random(affiliations, func(x): return x.bonding_A)
		friend={"satisfaction":friend_affiliation.satisfaction_A,"name":relationship_global_data.get_accounts()[friend_affiliation.id_B].origin.name}
	action.display_node.start_habitant_dialog(RELATIONSHIP_DIALOG,[{"relationship":self,"friend":friend,"friend_affiliation":friend_affiliation}])

func process(_delta : float):
	pass

func generate_request(residence : Residence) -> Array[Request]:
	load_relationship_global_data()
	var views = relationship_global_data.view_account(relationship_account)
	var account=relationship_global_data.get_account(relationship_account)
	if DEBUG:
		print("DEBUG RelationshipNeed.generate_request for ", habitant.name if habitant else "null")
		print("  relationship_account: ", relationship_account)
		print("  views count: ", len(views))
		print("  account: ", account)
	if not account:
		if DEBUG:
			print("  -> No account, returning empty")
		return []
	
	if DEBUG:
		print("  account.happiness: ", account.happiness)
	# If the habitant has no friends or is unhappy, try to befriend someone new
	if len(views)==0 or account.happiness<0.6:
		if DEBUG:
			print("  -> Should generate FriendRequest (no friends or unhappy)")
		var potential_friends=relationship_global_data.get_accounts().values()
		potential_friends.shuffle()
		if DEBUG:
			print("  potential_friends count: ", len(potential_friends))
		for acc in potential_friends:
			if acc.id!=relationship_account && acc.type==RelationshipAccount.AccountType.HABITANT:
				if DEBUG:
					print("  -> Creating FriendRequest with account ", acc.id)
				return [FriendRequest.create(residence,habitant,self,acc)]
	
	if DEBUG:
		print("  -> No request needed")
	return []
