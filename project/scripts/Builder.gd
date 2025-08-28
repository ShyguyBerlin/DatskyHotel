extends Node2D

@export var hotel : Hotel
@export var current_room : Room

# This should only be emitted when a build action moved/exchanged current room
signal current_room_changed(room : Room)
signal built_stuff

func set_current_room(room : Room):
	current_room=room

func build_room_to_left():
	if not current_room:
		return
	
	var connected_rooms = current_room.get_rooms_in_direction(RoomConnection.display_direction.DISPLAY_LEFT)
	if len(connected_rooms)>0:
		return
	
	var new_room= Room.new()
	current_room.connect_to_room(new_room,RoomConnection.display_direction.DISPLAY_LEFT)
	built_stuff.emit()

func build_room_to_right():
	if not current_room:
		return
	
	var connected_rooms = current_room.get_rooms_in_direction(RoomConnection.display_direction.DISPLAY_RIGHT)
	if len(connected_rooms)>0:
		return
	
	var new_room= Room.new()
	current_room.connect_to_room(new_room,RoomConnection.display_direction.DISPLAY_RIGHT)
	built_stuff.emit()

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
	
	current_room_changed.emit(new_residence)
	built_stuff.emit()
