extends Resource
class_name RelationshipAffiliationData
## Class to store affiliation data for the affiliation between a Habitant A and a Habitant B
## This is viewed as an analogy to the Graph edge A <-> B, respect that when interpreting variable names

# This is awkward
class AffiliationView:
	# If we view as B
	var flip : bool
	var affiliation : RelationshipAffiliationData
	
	func _get(name:StringName):
		if flip:
			if name.ends_with("_A"):
				name = StringName(String(name).replace("_A","_B"))
			else:
				name = StringName(String(name).replace("_B","_A"))
		return affiliation.get(name)
	
	func _set(property: StringName, value: Variant) -> bool:
		if flip:
			if property.ends_with("_A"):
				property = StringName(String(property).replace("_A","_B"))
			else:
				property = StringName(String(property).replace("_B","_A"))
		var valid_property=false
		for i in affiliation.get_property_list():
			if i["name"]==property:
				valid_property=true
				break
		if valid_property:
			affiliation.set(property,value)
		return valid_property
	
func _get_property_list() -> Array[Dictionary]:
	var props :Array[Dictionary] = []
	var base_props := [
		{ "name": "id",           "type": TYPE_INT },
		{ "name": "bonding",      "type": TYPE_FLOAT },
		{ "name": "satisfaction", "type": TYPE_FLOAT },
		{ "name": "happiness",    "type": TYPE_FLOAT }
	]
	for p in base_props:
		props.append({
			"name": p.name + "_A",
			"type": p.type,
			"usage": PROPERTY_USAGE_SCRIPT_VARIABLE
		})
		props.append({
			"name": p.name + "_B",
			"type": p.type,
			"usage": PROPERTY_USAGE_SCRIPT_VARIABLE
		})
	return props

func view(as_id:int) -> AffiliationView:
	var view_obj = AffiliationView.new()
	view_obj.flip = as_id==id_B
	view_obj.affiliation=self
	
	return view_obj

@export var id_A : int # RelationshipAccount for A
@export var id_B : int # RelationshipAccount for B

# This is the amount of energy put into the affiliation from the respective habitant
@export var bonding_A : float = 1
@export var bonding_B : float = 1

# This is a score for the affiliation, so the Habitant can prioritize based on this
# This is should be skewed towards affiliations with higher bonding
@export var satisfaction_A : float = 1
@export var satisfaction_B : float = 1

# In a fair affiliation, this should even out to 1
@export var happiness_A : float = 1
@export var happiness_B : float = 1
