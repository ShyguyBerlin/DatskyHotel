extends Resource
class_name RelationshipAccount

@export var id : int

@export var happiness : float = 1
@export var social_strength : float = 1

enum AccountType{
	HABITANT
}

@export var type : AccountType = AccountType.HABITANT
@export var origin : Variant
