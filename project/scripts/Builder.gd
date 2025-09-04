extends Node2D

@export var hotel : Hotel
@export var current_room : Room

# This should only be emitted when a build action moved/exchanged current room
signal current_room_changed(room : Room)
signal built_stuff

func set_current_room(room : Room):
	current_room=room

func build_room_to_left():
	return build_room_in_dir(RoomConnection.display_direction.DISPLAY_LEFT)

func build_room_to_right():
	return build_room_in_dir(RoomConnection.display_direction.DISPLAY_RIGHT)

func build_room_to_up():
	return build_room_in_dir(RoomConnection.display_direction.DISPLAY_UP)

func build_room_to_down():
	return build_room_in_dir(RoomConnection.display_direction.DISPLAY_DOWN)

func build_room_in_dir(dir : RoomConnection.display_direction):
	if not current_room:
		return
	
	var connected_rooms = current_room.get_rooms_in_direction(dir)
	if len(connected_rooms)>0:
		return
	
	var new_room= Room.new()
	current_room.connect_to_room(new_room,dir)
	built_stuff.emit()
	return new_room

func make_room_to_residence():
	if not current_room:
		return
	
	if not current_room is Room:
		return
	
	var new_residence = Residence.new()
	
	for i in current_room.connections:
		new_residence.connections.append(i)
		i.connected_rooms[new_residence]=i.connected_rooms.get(current_room)
		i.connected_rooms.erase(current_room)
	
	if current_room==HotelManager.hotel_instance.initial_room:
		HotelManager.hotel_instance.initial_room=new_residence
	current_room=new_residence
	current_room_changed.emit(new_residence)
	built_stuff.emit()
