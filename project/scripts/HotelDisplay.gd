extends Node2D
class_name HotelDisplay

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

class renderInfo:
	var room: Room
	var renderPosition:Vector2
	var distance:int
	func _init(room: Room, renderPosition:Vector2, distance:int):
		self.room=room
		self.renderPosition=renderPosition
		self.distance=distance

func draw_hotel():
	var children = get_children()
	for i in children:
		remove_child(i)
	
	var primary_room=current_room
	if primary_room==null:
		primary_room=HotelManager.hotel_instance.initial_room
	
	var bfs_rooms:Array[renderInfo]=[renderInfo.new(primary_room,Vector2(0,0),0)]
	var banned_connections=[]
	var banned_rooms=[primary_room]
	
	var bl_corner:Vector2=bfs_rooms[0].renderPosition
	var tr_corner:Vector2=bfs_rooms[0].renderPosition
	
	while len(bfs_rooms)>0:
		var info : renderInfo = bfs_rooms.pop_back()
		var render_room= info.room
		var render_position = info.renderPosition
		var render_node = render_room.get_display_node()
		
		# Actually render room
		if render_node:
			add_child(render_node)
			render_node.position=render_position
			bl_corner.x=min(bl_corner.x,render_position.x+render_room.get_size(RoomConnection.display_direction.DISPLAY_LEFT).x/2)
			bl_corner.y=min(bl_corner.y,render_position.y+render_room.get_size(RoomConnection.display_direction.DISPLAY_DOWN).y/2)
			tr_corner.x=max(tr_corner.x,render_position.x+render_room.get_size(RoomConnection.display_direction.DISPLAY_RIGHT).x/2)
			tr_corner.y=max(tr_corner.y,render_position.y+render_room.get_size(RoomConnection.display_direction.DISPLAY_UP).y/2)
		
		
		# Add all connected rooms to the search, ignore already considered rooms
		for i : RoomConnection in render_room.connections:
			if i in banned_connections:
				continue
			banned_connections.append(i)
			
			var connection_position = render_position+i.get_size(RoomConnection.invert_display_direction(i.connected_rooms.get(render_room)))/2  +  render_room.get_size(RoomConnection.invert_display_direction(i.connected_rooms.get(render_room)))/2
			
			var connection_node = i.get_display_node()
			
			# Actually render connection
			if connection_node:
				add_child(connection_node)
				connection_node.position=connection_position
				bl_corner.x=min(bl_corner.x,connection_position.x+i.get_size(RoomConnection.display_direction.DISPLAY_LEFT).x/2)
				bl_corner.y=min(bl_corner.y,connection_position.y+i.get_size(RoomConnection.display_direction.DISPLAY_DOWN).y/2)
				tr_corner.x=max(tr_corner.x,connection_position.x+i.get_size(RoomConnection.display_direction.DISPLAY_RIGHT).x/2)
				tr_corner.y=max(tr_corner.y,connection_position.y+i.get_size(RoomConnection.display_direction.DISPLAY_UP).y/2)

			for r in i.connected_rooms.keys():
				if r == render_room:
					continue
				if r in banned_rooms:
					continue
				banned_rooms.append(r)
				var room_position = connection_position+i.get_size(i.connected_rooms.get(r))/2  +  r.get_size(i.connected_rooms.get(r))/2
				var is_horizontal = i.connected_rooms.get(r)==RoomConnection.display_direction.DISPLAY_LEFT || i.connected_rooms.get(r)==RoomConnection.display_direction.DISPLAY_RIGHT
				bfs_rooms.append(renderInfo.new(r,room_position,info.distance+ (1 if is_horizontal else 10)))
	
	if not current_room:
		var draw_size= tr_corner-bl_corner
		var general_offset:Vector2=-draw_size/2-bl_corner
		for i in get_children():
			i.position+=general_offset
