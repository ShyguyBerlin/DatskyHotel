extends Node

@export var hotel_display_node : HotelDisplay

func _ready() -> void:
	
	
	TranslationServer.set_locale("en_en")
	
	
	var a = Hotel.new()
	a.initial_room = Room.new()
	
	var b = Room.new()
	
	a.initial_room.connect_to_room(b,RoomConnection.display_direction.DISPLAY_RIGHT)
	
	var c = Room.new()
	
	b.connect_to_room(c,RoomConnection.display_direction.DISPLAY_RIGHT)

	HotelManager.hotel_instance=a
	
	if hotel_display_node:
		hotel_display_node.current_room=a.initial_room
