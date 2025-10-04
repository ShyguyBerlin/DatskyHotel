extends Resource
class_name Hotel

@export var initial_room : Room
@export var register : HabitantRegister
@export var requests : Array[Request] = []

func _init():
	register=HabitantRegister.new()

# Shall return a node which displays the properties of this Resource
func get_display_node():
	return load("res://nodes/HotelDisplay.tscn")

func size():
	return len(get_rooms())

class RoomInfo:
	var room:Room
	var pos:Vector2i

func get_rooms() -> Array[Room]:
	var start_info :RoomInfo= RoomInfo.new()
	start_info.room=initial_room
	start_info.pos=Vector2i.ZERO
	var room_check_stack : Array[RoomInfo]= [start_info]
	var room_ignores : Array[Room]= [start_info.room]
	while not room_check_stack.is_empty():
		var next : RoomInfo=room_check_stack.pop_back()
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
				room_check_stack.append(conn_room_info)
	return room_ignores
