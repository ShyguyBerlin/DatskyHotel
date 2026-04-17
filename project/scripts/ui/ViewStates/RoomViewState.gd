extends StateMachineState

@export var current_room_storage : Node
@onready var room_interior: Node3D = %RoomInterior

func _enter():
	room_interior.room=current_room_storage.get("current_room")
	for child in get_children():
		if child.has_method("show"):
			child.show()

func _leave():
	for child in get_children():
		if child.has_method("hide"):
			child.hide()
	current_room_storage.set("current_room",room_interior.room)
