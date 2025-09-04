extends Node

@export var hotel_display_node : HotelDisplay

func move_dir(dir : RoomConnection.display_direction):
	if not hotel_display_node:
		return
	
	# connection which lies in the given direction
	var connection_passing=null
	var croom : Room = hotel_display_node.current_room
	
	# find connection, which points to the current room in the inverted direction
	for i in croom.connections:
		var croom_to_dir = i.connected_rooms.get(croom)
		if croom_to_dir != null and croom_to_dir == RoomConnection.invert_display_direction(dir):
			connection_passing=i
			break
	
	if not connection_passing:
		return
	
	# find a room which is in the correct direction
	for i in connection_passing.connected_rooms.keys():
		if connection_passing.connected_rooms.get(i)==dir:
			hotel_display_node.current_room=i
			return

func move_left():
	return move_dir(RoomConnection.display_direction.DISPLAY_LEFT)

func move_right():
	return move_dir(RoomConnection.display_direction.DISPLAY_RIGHT)

func move_up():
	return move_dir(RoomConnection.display_direction.DISPLAY_UP)

func move_down():
	return move_dir(RoomConnection.display_direction.DISPLAY_DOWN)

func unselect_room():
	if not hotel_display_node:
		return
	hotel_display_node.current_room=null

func select_initial_room():
	if not hotel_display_node:
		return
	hotel_display_node.current_room=HotelManager.hotel_instance.initial_room

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("hotel_move_left"):
		move_left()
	if event.is_action_pressed("hotel_move_right"):
		move_right()
	if event.is_action_pressed("hotel_move_up"):
		move_up()
	if event.is_action_pressed("hotel_move_down"):
		move_down()
