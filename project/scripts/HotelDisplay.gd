@icon("res://Assets/Images/SVG/DatskyHotelIcon.svg")
extends Node2D
class_name HotelDisplay
# this is not necessary as the HotelManager handles the hotel instance
#var hotel:Hotel = ...

signal current_room_changed(new_room : Room)

signal generated_new_spatial_room_finder(room_finder : HotelSpatialRoomFinder)

var current_room : set = change_current_room

## Node instantiation stuff
@onready var display_nodes_folder: Node = %DisplayNodesFolder
@onready var terrain_sprite_rect: NinePatchRect = %TerrainSpriteRect
@onready var building_sprite_rect: NinePatchRect = %BuildingSpriteRect

# I really do not want this to exist
var room_mapping : Dictionary # dataclass -> displaynode

# Center of the rendered area, offsetting this to 0 will make everything look equal distance apart
var rendered_center : Vector2 = Vector2.ZERO

# The current offset applied to all rooms as the vector from 0,0 to the offset position of the inital room
var current_offset:Vector2=Vector2.ZERO

## Node instantiation stuff end

func _ready() -> void:
	draw_hotel()
	

func change_current_room(new_room):
	if current_room==new_room:
		return
	
	current_room = new_room
	if current_room:
		center_around_current_room()
	else:
		center_around_center()
	current_room_changed.emit(current_room)

class renderInfo:
	var room: Room
	var renderPosition:Vector2
	var distance:int
	func _init(room: Room, renderPosition:Vector2, distance:int):
		self.room=room
		self.renderPosition=renderPosition
		self.distance=distance

func get_current_display_node():
	return room_mapping[current_room]

func draw_hotel():
	
	var children = display_nodes_folder.get_children()
	for i in children:
		display_nodes_folder.remove_child(i)
	room_mapping.clear()
	current_offset=Vector2.ZERO
	for i in get_children():
		i.position=Vector2.ZERO
	# With an implementation for offset, the initial room should always the hotels initial room
	var primary_room=current_room
	if primary_room==null or true:
		if HotelManager.hotel_instance:
			primary_room=HotelManager.hotel_instance.initial_room
	if not primary_room:
		return
	var bfs_rooms:Array[renderInfo]=[renderInfo.new(primary_room,Vector2(0,0),0)]
	var banned_connections=[]
	var banned_rooms=[primary_room]
	
	var bl_corner = bfs_rooms[0].renderPosition
	var tr_corner = bfs_rooms[0].renderPosition
	
	var room_areas : Array[Rect2]= []
	var room_nodes : Array[Node2D]= []

	while len(bfs_rooms)>0:
		var info : renderInfo = bfs_rooms.pop_back()
		var render_room= info.room
		var render_position = info.renderPosition
		var render_node = render_room.get_display_node()
		# Actually render room
		if render_node:
			room_mapping[render_room]=render_node
			display_nodes_folder.add_child(render_node)
			render_node.position=render_position
			bl_corner.x=min(bl_corner.x,render_position.x+render_room.get_size(RoomConnection.display_direction.DISPLAY_LEFT).x)
			bl_corner.y=min(bl_corner.y,render_position.y+render_room.get_size(RoomConnection.display_direction.DISPLAY_UP).y)
			tr_corner.x=max(tr_corner.x,render_position.x+render_room.get_size(RoomConnection.display_direction.DISPLAY_RIGHT).x)
			tr_corner.y=max(tr_corner.y,render_position.y+render_room.get_size(RoomConnection.display_direction.DISPLAY_DOWN).y)

			room_nodes.append(render_node)
			room_areas.append(Rect2(Vector2(render_position.x+render_room.get_size(RoomConnection.display_direction.DISPLAY_LEFT).x/2,render_position.y+render_room.get_size(RoomConnection.display_direction.DISPLAY_UP).y/2),render_room.get_total_size()))

		
		# Add all connected rooms to the search, ignore already considered rooms
		for i : RoomConnection in render_room.connections:
			if i in banned_connections:
				continue
			banned_connections.append(i)
			
			var connection_position = render_position+i.get_size(RoomConnection.invert_display_direction(i.connected_rooms.get(render_room)))/2  +  render_room.get_size(RoomConnection.invert_display_direction(i.connected_rooms.get(render_room)))/2
			
			var connection_node = i.get_display_node()
			
			# Actually render connection
			if connection_node:
				display_nodes_folder.add_child(connection_node)
				connection_node.position=connection_position
				bl_corner.x=min(bl_corner.x,connection_position.x+i.get_size(RoomConnection.display_direction.DISPLAY_LEFT).x)
				bl_corner.y=min(bl_corner.y,connection_position.y+i.get_size(RoomConnection.display_direction.DISPLAY_UP).y)
				tr_corner.x=max(tr_corner.x,connection_position.x+i.get_size(RoomConnection.display_direction.DISPLAY_RIGHT).x)
				tr_corner.y=max(tr_corner.y,connection_position.y+i.get_size(RoomConnection.display_direction.DISPLAY_DOWN).y)

			for r in i.connected_rooms.keys():
				if r == render_room:
					continue
				if r in banned_rooms:
					continue
				banned_rooms.append(r)
				var room_position = connection_position+i.get_size(i.connected_rooms.get(r))/2  +  r.get_size(i.connected_rooms.get(r))/2
				var is_horizontal = i.connected_rooms.get(r)==RoomConnection.display_direction.DISPLAY_LEFT || i.connected_rooms.get(r)==RoomConnection.display_direction.DISPLAY_RIGHT
				bfs_rooms.append(renderInfo.new(r,room_position,info.distance+ (1 if is_horizontal else 10)))

	var room_finder:HotelSpatialRoomFinder=HotelSpatialRoomFinder.new()

	room_finder.construct_spatial_map(room_areas,room_nodes)

	if not current_room:
		center_around_center()
	else:
		center_around_current_room()
	
	
	building_sprite_rect.position=bl_corner
	building_sprite_rect.size=tr_corner-bl_corner
	rendered_center = (tr_corner-bl_corner)/2+bl_corner
	generated_new_spatial_room_finder.emit(room_finder)

func displaynode_real_position(node):
	return node.position#-current_offset

func center_around(pos:Vector2):
		var practical_translation:Vector2 = -pos - current_offset
		for i in get_children():
			i.position+=practical_translation
		current_offset=-pos

func center_around_center():
		center_around(rendered_center)

func center_around_current_room():
	# no hotel to center
	if not room_mapping:
		return
	
	# current room not drawn
	if not current_room in room_mapping:
		return
	center_around(displaynode_real_position(room_mapping[current_room]))
