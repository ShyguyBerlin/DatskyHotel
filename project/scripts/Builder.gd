extends Node
class_name HotelBuilder

@export var current_room : Room

# This should only be emitted when a build action moved/exchanged current room
signal current_room_changed(room : Room)
signal built_stuff

func set_current_room(room : Room):
	current_room=room

func build_room_to_left():
	return build_room_in_dir(RoomConnection.display_direction.DISPLAY_LEFT,Room.new())

func build_room_to_right():
	return build_room_in_dir(RoomConnection.display_direction.DISPLAY_RIGHT,Room.new())

func build_room_to_up():
	return build_room_in_dir(RoomConnection.display_direction.DISPLAY_UP,Elevator.new())

func build_room_to_down():
	return build_room_in_dir(RoomConnection.display_direction.DISPLAY_DOWN,Elevator.new())

class RoomInfo:
	var room:Room
	var pos:Vector2i

# Searches the whole room structure tree and returns the first room found
# Uses Depth-first-search
func find_room_at_offset(origin:Room, offset:Vector2i)->Room:
	var start_info :RoomInfo= RoomInfo.new()
	start_info.room=origin
	start_info.pos=Vector2i.ZERO
	var room_check_stack : Array[RoomInfo]= [start_info]
	var room_ignores = [start_info.room]
	while not room_check_stack.is_empty():
		var next : RoomInfo=room_check_stack.pop_back()
		print("checking room of type ",next.room.get_script().get_global_name()," at position ",next.pos)
		for next_conn in next.room.connections:
			for connected_room in next_conn.connected_rooms:
				if connected_room==next:
					continue
				if connected_room in room_ignores:
					continue
				room_ignores.append(connected_room)
				var conn_room_info = RoomInfo.new()
				conn_room_info.pos=next.pos+RoomConnection.get_display_direction_vector(next_conn.connected_rooms[connected_room])
				conn_room_info.room=connected_room
				if conn_room_info.pos==offset:
					return conn_room_info.room
				room_check_stack.append(conn_room_info)
	return null

func build_room_in_dir(dir : RoomConnection.display_direction,new_room:Room):
	if not current_room:
		return
	
	var connected_rooms = current_room.get_rooms_in_direction(dir)
	if len(connected_rooms)>0:
		return
	
	# Check if there is a room at that position
	var conflict_pos : Vector2i= RoomConnection.get_display_direction_vector(dir)
	var conflict_room = find_room_at_offset(current_room,conflict_pos)
	if conflict_room:
		if RoomConnection.is_direction_horizontal(dir):
			current_room.connect_to_room(conflict_room,dir)
		elif conflict_room is Elevator:
				current_room.connect_to_room(conflict_room,dir)
		else:
			print("Could not construct room due to obstruction")
		built_stuff.emit()
		return
	
	
	current_room.connect_to_room(new_room,dir)
	built_stuff.emit()
	return new_room

func swap_current_room_with(room:Room):
	if not current_room:
		return
	
	if not current_room is Room:
		return
	
	for i in current_room.connections:
		room.connections.append(i)
		i.connected_rooms[room]=i.connected_rooms.get(current_room)
		i.connected_rooms.erase(current_room)
	
	if current_room==HotelManager.hotel_instance.initial_room:
		HotelManager.hotel_instance.initial_room=room
	current_room=room
	current_room_changed.emit(room)

func make_room_to_residence():
	var new_residence = Residence.new()
	swap_current_room_with(new_residence)
	built_stuff.emit()

func make_room_to_elevator():
	var new_elevator = Elevator.new()
	swap_current_room_with(new_elevator)
	built_stuff.emit()
