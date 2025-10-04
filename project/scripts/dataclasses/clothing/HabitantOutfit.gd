extends Resource
class_name HabitantOutfit

enum BodyType {
	DEFAULT,
	DEBUG
}

static func get_skin_for_bodytype(bt : BodyType) -> Clothing:
	var outfits={
		BodyType.DEFAULT: "res://Assets/Clothing/BodyTypes/Default.tres",
		BodyType.DEBUG: "res://Assets/Clothing/BodyTypes/Debug.tres"
	}
	return load(outfits.get(bt))
@export var headwear           : Clothing
@export var facial_accessories : Clothing
@export var torso_behind       : Clothing
@export var torso_front        : Clothing
@export var pants              : Clothing
@export var shoes              : Clothing
@export var hand_accessories   : Clothing
