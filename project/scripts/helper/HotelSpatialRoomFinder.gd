class_name HotelSpatialRoomFinder
extends Object

var spatial_block_size : Vector2 = Vector2(80,60)

var covered_rect : Rect2

var spatial_map : Dictionary # Maps Vector2 -> Array[DisplayNode]

class SpatialMapEntry:
	var area: Rect2
	var key
	func _init(area:Rect2,key):
		self.area=area
		self.key=key

func to_map_coords(pos:Vector2) -> Vector2i:
	var rel_pos=pos-covered_rect.position
	return Vector2i(floor(rel_pos.x/spatial_block_size.x),floor(rel_pos.y/spatial_block_size.y))

func construct_spatial_map(node_areas:Array[Rect2],nodes:Array[Node2D]):
	var tl_corner=Vector2.ZERO
	var br_corner=Vector2.ZERO

	spatial_map.clear()

	if len(node_areas) != len(nodes):
		printerr("Node information not matching")
		print_stack()
		return

	for node in node_areas:
		var c1 = node.position
		var c2 = node.position+abs(node.size)
		tl_corner.x=min(tl_corner.x,c1.x)
		tl_corner.y=min(tl_corner.y,c1.y)
		br_corner.x=max(br_corner.x,c2.x)
		br_corner.y=max(br_corner.y,c2.y)
	
	covered_rect=Rect2(tl_corner,br_corner-tl_corner)

	for i in range(len(node_areas)):
		var c1 = node_areas[i].position
		var c2 = node_areas[i].position+node_areas[i].size
		var block_1 = to_map_coords(c1)
		var block_2 = to_map_coords(c2)
		for bx in range(block_1.x,block_2.x+1):
			for by in range(block_1.y,block_2.y+1):
				if Vector2i(bx,by) in spatial_map:
					spatial_map[Vector2i(bx,by)].append(SpatialMapEntry.new(node_areas[i],nodes[i]))
				else:
					spatial_map[Vector2i(bx,by)]=[SpatialMapEntry.new(node_areas[i],nodes[i])]

func find_room(pos:Vector2) -> Array:
	var block_pos = to_map_coords(pos)
	if not block_pos in spatial_map:
		return []
	var block : Array= spatial_map[block_pos]
	var eligible = []
	for i in block:
		if i.area.has_point(pos):
			eligible.append(i.key)
	return eligible
