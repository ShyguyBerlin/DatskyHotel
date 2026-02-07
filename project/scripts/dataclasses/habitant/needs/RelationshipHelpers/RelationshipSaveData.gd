extends Resource
class_name RelationshipSaveData
## Everything there is to save about relationships
## 
## As relationships require a lot of calculations and depend a lot on each other, referencing them only in the needs of certain habitants would be hard to deal with
## Thus the relationship-network is stored here.

## For naming purposes, we call the relationship between two individual habitants an 'Affiliation'

# Nested Dictionary, id -> id -> AffiliationData
@export var _affiliation_index : Dictionary={}
@export var _affiliation_list : Array[RelationshipAffiliationData] = []
@export var _accounts : Dictionary[int,RelationshipAccount] = {}

# Very cool, I love centralistic id counters, surely nothing bad is gonna happen to it - 14.12.2025
@export var _account_id_counter : int = 0

func _init() -> void:
	if not GameTimeManager.MediumCycleTick.is_connected(on_relationship_cycle):
		GameTimeManager.MediumCycleTick.connect(on_relationship_cycle)

static func create() -> RelationshipSaveData:
	var savedata=RelationshipSaveData.new()
	#GameTimeManager.MediumCycleTick.connect(savedata.on_relationship_cycle)
	return savedata

func create_habitant_account(habitant: Habitant) -> RelationshipAccount:
	var acc = RelationshipAccount.new()
	acc.id=_account_id_counter
	acc.type=RelationshipAccount.AccountType.HABITANT
	acc.origin=habitant
	_account_id_counter+=1
	_accounts[acc.id]=acc
	print("Creating Relationship Account")
	return acc

# For the unlikely case of a habitant being deleted
# It is really awkward ngl
func delete_account(account : int) -> void:
	if account in _affiliation_index:
		var affiliations : Array= (_affiliation_index[account] as Dictionary).keys()
		
		for i in affiliations:
			_affiliation_index[i].erase(account)
			_affiliation_list.erase(_affiliation_index[account][i])
		_affiliation_index.erase(account)
	
	_accounts.erase(account)

func get_account(account : int) -> RelationshipAccount:
	if account in _accounts:
		return _accounts[account]
	return null

func view_account(account : int):
	if not account in _affiliation_index:
		return []
	var acc_idx = _affiliation_index[account]
	var views= []
	
	for i in acc_idx.values():
		views.append(i.view(account))

	return views

func get_accounts():
	return _accounts

func befriend_accounts(id_a,id_b):
	if id_a in _affiliation_index and id_b in _affiliation_index[id_a].keys():
		printerr("Accounts ",id_a," and ",id_b," are already befriended")
		return
	var edge=RelationshipAffiliationData.new()
	edge.id_A=id_a
	edge.id_B=id_b
	_affiliation_list.append(edge)
	_affiliation_index.get_or_add(id_a,{})[id_b]=edge
	_affiliation_index.get_or_add(id_b,{})[id_a]=edge
	print("Accounts ",id_a," and ",id_b," are now befriended")

func on_relationship_cycle(ticks:int):
	ticks=min(ticks,20)
	for i in range(ticks):
		do_simulation_cycle()

func do_simulation_cycle() -> void:
	# --- Step 1: bonding
	for a : int in _accounts:
		if a not in _affiliation_index:
			continue
		var a_idx : Dictionary=_affiliation_index[a]
		var neighbor_ids = a_idx.keys()
		var satifaction_sum = 0
		for nid in neighbor_ids:
			var edge : RelationshipAffiliationData.AffiliationView = a_idx[nid].view(a)
			satifaction_sum += edge.satisfaction_A
		if satifaction_sum == 0:
			continue

		for nid in neighbor_ids:
			var edge : RelationshipAffiliationData.AffiliationView = a_idx[nid].view(a)
			print("Setting edge bonding ",edge.bonding_A)
			edge.bonding_A=(edge.satisfaction_A / satifaction_sum) * _accounts[a].social_strength
			print("To ",edge.bonding_A)
	# --- Step 2: satisfaction and happiness
	for a : int in _accounts:
		if a not in _affiliation_index:
			continue
		var a_idx : Dictionary=_affiliation_index[a]
		var neighbor_ids = a_idx.keys()
		var account_happiness_sum = 0
		for nid in neighbor_ids:
			var edge : RelationshipAffiliationData.AffiliationView = a_idx[nid].view(a)
			var ratio = edge.bonding_B / edge.bonding_A if edge.bonding_A > 0 else 1
			# Satisfaction orients itself on the ratio of bonding, but increases with stronger bondings
			edge.satisfaction_A = ratio if edge.bonding_B < 1 else (ratio + edge.bonding_B) / 2
			# Happiness is equal to bonding from the other side
			# Should sum up to the social energy, so investment is equal to return
			# If its lower the account should search for new affiliations
			edge.happiness_A = edge.bonding_B
			account_happiness_sum += edge.happiness_A
		account_happiness_sum /= _accounts[a].social_strength
		_accounts[a].happiness = account_happiness_sum
