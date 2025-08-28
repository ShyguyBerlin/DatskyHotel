extends Node2D

# this is not necessary as the HotelManager handles the hotel instance
#var hotel:Hotel = ...

signal current_room_changed(new_room : Room)

var current_room : set = change_current_room

func change_current_room(new_room):
	if current_room==new_room:
		return
	
	current_room = new_room
	
	draw_hotel()
	
	current_room_changed.emit(current_room)

func draw_hotel():
	var children = get_children()
	for i in children:
		remove_child(i)
	
	if current_room==null:
		return
	
	var bfs_rooms=[[current_room,0,Vector2(0,0)]]
	var banned_connections=[]
	while len(bfs_rooms)>0:
		var render_info = bfs_rooms.pop_back()
		var render_room= render_info[0]
		var render_position = render_info[2]
		var render_node = render_room.get_display_node()
		
		if render_node:
			add_child(render_node)
			render_node.position=render_position
		# Add all connected rooms to the search, ignore already considered rooms
		for i : RoomConnection in render_room.connections:
			if i in banned_connections:
				continue
			banned_connections.append(i)
			
			var connection_position = render_position+i.get_size(RoomConnection.invert_display_direction(i.connected_rooms.get(render_room)))/2  +  render_room.get_size(RoomConnection.invert_display_direction(i.connected_rooms.get(render_room)))/2
			
			var connection_node = i.get_display_node()
			if connection_node:
				add_child(connection_node)
				connection_node.position=connection_position
			
			for r in i.connected_rooms.keys():
				if r == render_room:
					continue
				var room_position = connection_position+i.get_size(i.connected_rooms.get(r))/2  +  r.get_size(i.connected_rooms.get(r))/2
				var is_horizontal = i.connected_rooms.get(r)==RoomConnection.display_direction.DISPLAY_LEFT || i.connected_rooms.get(r)==RoomConnection.display_direction.DISPLAY_RIGHT
				bfs_rooms.append([r,render_info[1]+ (1 if is_horizontal else 10),room_position])
