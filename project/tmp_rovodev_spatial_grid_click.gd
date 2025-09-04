# Spatial Grid Click Detection - O(1) average case!
# Even faster than binary search for very large hotels

extends Node2D

# Spatial grid for O(1) lookup
var grid_cell_size: Vector2 = Vector2(100, 80)  # Slightly larger than room size
var spatial_grid: Dictionary = {}  # Vector2i(grid_x, grid_y) -> Array[Room]
var room_positions: Dictionary = {}
var room_bounds: Dictionary = {}
var grid_bounds: Rect2

func cache_room_positions_spatial_grid():
	"""Create spatial grid for O(1) room lookup"""
	room_positions.clear()
	spatial_grid.clear()
	room_bounds.clear()
	
	var min_pos = Vector2(INF, INF)
	var max_pos = Vector2(-INF, -INF)
	
	# First pass: collect positions and find bounds
	for child in get_children():
		if child.has_method("get_room_data"):
			var room = child.get_room_data()
			if room:
				room_positions[room] = child.position
				min_pos.x = min(min_pos.x, child.position.x)
				min_pos.y = min(min_pos.y, child.position.y)
				max_pos.x = max(max_pos.x, child.position.x)
				max_pos.y = max(max_pos.y, child.position.y)
				
				# Calculate room bounds
				var room_size = Vector2(80, 60)
				room_bounds[room] = Rect2(child.position - room_size/2, room_size)
	
	# Set grid bounds
	grid_bounds = Rect2(min_pos - grid_cell_size, max_pos - min_pos + grid_cell_size * 2)
	
	# Second pass: populate spatial grid
	for room in room_positions.keys():
		var room_pos = room_positions[room]
		var room_rect = room_bounds[room]
		
		# Find all grid cells this room overlaps
		var start_cell = world_to_grid(room_rect.position)
		var end_cell = world_to_grid(room_rect.position + room_rect.size)
		
		for grid_x in range(start_cell.x, end_cell.x + 1):
			for grid_y in range(start_cell.y, end_cell.y + 1):
				var grid_coord = Vector2i(grid_x, grid_y)
				if not spatial_grid.has(grid_coord):
					spatial_grid[grid_coord] = []
				spatial_grid[grid_coord].append(room)

func world_to_grid(world_pos: Vector2) -> Vector2i:
	"""Convert world position to grid coordinates"""
	var relative_pos = world_pos - grid_bounds.position
	return Vector2i(
		int(relative_pos.x / grid_cell_size.x),
		int(relative_pos.y / grid_cell_size.y)
	)

func find_room_at_click_position_spatial(click_pos: Vector2) -> Room:
	"""O(1) average case room finding using spatial grid"""
	var grid_coord = world_to_grid(click_pos)
	
	# Get rooms in this grid cell
	if not spatial_grid.has(grid_coord):
		return null
	
	var candidate_rooms = spatial_grid[grid_coord]
	
	# Check exact bounds for candidates (usually 1-3 rooms per cell)
	for room in candidate_rooms:
		if room_bounds[room].has_point(click_pos):
			return room
	
	return null

# Comparison of all three approaches:
func benchmark_click_detection(click_pos: Vector2, iterations: int = 1000):
	"""Compare performance of different approaches"""
	var start_time: int
	var end_time: int
	
	print("Benchmarking click detection with ", room_positions.size(), " rooms")
	
	# Linear search O(n)
	start_time = Time.get_ticks_msec()
	for i in iterations:
		find_room_at_click_position_linear(click_pos)
	end_time = Time.get_ticks_msec()
	print("Linear O(n): ", end_time - start_time, "ms")
	
	# Binary search O(log n)
	start_time = Time.get_ticks_msec()
	for i in iterations:
		find_room_at_click_position_binary(click_pos)
	end_time = Time.get_ticks_msec()
	print("Binary O(log n): ", end_time - start_time, "ms")
	
	# Spatial grid O(1)
	start_time = Time.get_ticks_msec()
	for i in iterations:
		find_room_at_click_position_spatial(click_pos)
	end_time = Time.get_ticks_msec()
	print("Spatial O(1): ", end_time - start_time, "ms")

func find_room_at_click_position_linear(click_pos: Vector2) -> Room:
	"""Original O(n) approach for comparison"""
	for room in room_positions.keys():
		if room_bounds[room].has_point(click_pos):
			return room
	return null

# Usage recommendation based on hotel size:
func get_recommended_approach() -> String:
	var room_count = room_positions.size()
	
	if room_count < 50:
		return "Linear search - overhead not worth it for small hotels"
	elif room_count < 500:
		return "Binary search - good balance of complexity and performance"
	else:
		return "Spatial grid - best for large hotels with 500+ rooms"

# Final optimized click handler
func _on_hotel_clicked_final(viewport: Node, event: InputEvent, shape_idx: int):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var local_click_pos = to_local(event.global_position)
		
		# Choose approach based on hotel size
		var clicked_room: Room
		if room_positions.size() < 500:
			clicked_room = find_room_at_click_position_binary(local_click_pos)
		else:
			clicked_room = find_room_at_click_position_spatial(local_click_pos)
		
		if clicked_room:
			print("Room found: ", clicked_room)
			handle_room_click(clicked_room)
		else:
			print("Empty space clicked")
			handle_empty_space_click()
