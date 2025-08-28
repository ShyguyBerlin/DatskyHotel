extends Node2D

@export var hotel_display_node : Node2D

func _ready() -> void:
	
	
	TranslationServer.set_locale("en_en")
	
	
	var a = Hotel.new()
	a.initial_room = Room.new()
	
	var b = Room.new()
	
	a.initial_room.connect_to_room(b,RoomConnection.display_direction.DISPLAY_RIGHT)
	
	var c = Room.new()
	
	b.connect_to_room(c,RoomConnection.display_direction.DISPLAY_RIGHT)

	HotelManager.hotel_instance=a

	hotel_display_node.current_room=a.initial_room

func move_left():
	var connection_left=null
	var croom : Room = hotel_display_node.current_room
	for i in croom.connections:
		var dir = i.connected_rooms.get(croom)
		if dir != null and dir == RoomConnection.invert_display_direction(RoomConnection.display_direction.DISPLAY_LEFT):
			connection_left=i
			break
	
	if not connection_left:
		return
	
	for i in connection_left.connected_rooms.keys():
		if connection_left.connected_rooms.get(i)==RoomConnection.display_direction.DISPLAY_LEFT:
			hotel_display_node.current_room=i
			return

func move_right():
	var connection_right=null
	var croom : Room = hotel_display_node.current_room
	for i in croom.connections:
		var dir = i.connected_rooms.get(croom)
		if dir != null and dir == RoomConnection.invert_display_direction(RoomConnection.display_direction.DISPLAY_RIGHT):
			connection_right=i
			break
	
	if not connection_right:
		return
	
	for i in connection_right.connected_rooms.keys():
		if connection_right.connected_rooms.get(i)==RoomConnection.display_direction.DISPLAY_RIGHT:
			hotel_display_node.current_room=i
			return



func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_left"):
		move_left()
	if event.is_action_pressed("ui_right"):
		move_right()
