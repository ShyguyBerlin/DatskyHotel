extends StateMachineState

@export var hotel_display : HotelDisplay
@export var current_room_storage : Node

func _enter():
	for child in get_children():
		if child.has_method("show"):
			child.show()
	if hotel_display and current_room_storage:
		hotel_display.current_room=current_room_storage.get("current_room")
		hotel_display.center_around_current_room(false)
func _leave():
	for child in get_children():
		if child.has_method("hide"):
			child.hide()
	if hotel_display and current_room_storage:
		current_room_storage.set("current_room",hotel_display.current_room)
