extends Node

const TIME_BETWEEN_CYCLES=20
var timer=TIME_BETWEEN_CYCLES

signal request_cycle_tick(percentage:float)
signal new_request_cycle()

func _ready():
	GameTimeManager.ShortCycleTick.connect(on_short_cycle_ticks)
	GameTimeManager.ShortCycleProgress.connect(request_cycle_tick.emit)
#func _process(delta: float) -> void:
#	timer-=delta
#	request_cycle_tick.emit((TIME_BETWEEN_CYCLES-timer)/TIME_BETWEEN_CYCLES)
#	if timer<0:
#		timer=TIME_BETWEEN_CYCLES
#		perform_request_cycle(HotelManager.hotel_instance)

func on_short_cycle_ticks(num:int):
	num=min(num,5)
	for i in range(num):
		perform_request_cycle(HotelManager.hotel_instance)

func perform_request_cycle(hotel:Hotel=null) -> void:
	if hotel==null:
		hotel=HotelManager.hotel_instance
	if hotel==null:
		return
	
	var rooms : Array[Room]=hotel.get_rooms()
	
	# ========== STEP 1: Collect proposed requests from all rooms ==========
	# Maps room type (String) -> Array of proposed requests from rooms of that type
	var proposed_requests_by_type = {}
	# Maps room type (String) -> count of rooms of that type
	var room_type_counts = {}
	
	for room : Room in rooms:
		var room_type = room.get_script().get_global_name()
		
		# Initialize dictionaries for new room types
		if not room_type in proposed_requests_by_type:
			proposed_requests_by_type[room_type] = []
			room_type_counts[room_type] = 0
		
		# Collect all proposed requests from this room
		proposed_requests_by_type[room_type].append_array(room.generate_request())
		room_type_counts[room_type] += 1
	
	# ========== STEP 2: Filter old requests that should survive ==========
	# Base survival: ~20%, scales with priority (higher priority = higher survival)
	# Priority 1: ~23%, Priority 5: ~55%, Priority 10: ~95%
	var surviving_old_requests_by_type = {}
	
	for old_request in hotel.requests:
		var survival_chance = 0.15 + old_request.priority * 0.08
		if randf() < survival_chance:
			var room_type = old_request.origin.get_script().get_global_name()
			
			if not room_type in surviving_old_requests_by_type:
				surviving_old_requests_by_type[room_type] = []
			
			surviving_old_requests_by_type[room_type].append(old_request)
	
	# ========== STEP 3: Select new requests per room type ==========
	var final_requests : Array[Request] = []
	
	for room_type in proposed_requests_by_type.keys():
		var type_count = room_type_counts[room_type]
		var old_request_count = len(surviving_old_requests_by_type.get(room_type, []))
		
		# Calculate target range based on room type and count
		var target_min : int
		var target_max : int
		
		if room_type == "Residence":
			# Residence rooms generate more requests (scale with hotel size)
			if type_count <= 3:
				target_max = round(type_count)
			elif type_count <= 10:
				target_max = round(2.0 / 5.0 * type_count + 1.8)
			else:
				target_max = round(sqrt(type_count + 10) + 1.4)
			target_min = round(sqrt(type_count * 0.6 + 3) - 1)
		else:
			# Other room types generate fewer requests
			target_max = round(sqrt(type_count * 0.6 + 3) - 1)
			target_min = 0
		
		# Calculate how many NEW requests we need (accounting for surviving old ones)
		var new_request_target = randi_range(target_min, target_max) - old_request_count
		if new_request_target < 0:
			new_request_target = 0
		
		# Prepare proposed requests: shuffle and sort by priority (highest first)
		var proposed : Array = proposed_requests_by_type[room_type]
		proposed = proposed as Array[Request]
		proposed.shuffle()
		proposed.sort_custom(func(a, b): return a.priority > b.priority)
		
		# Select new requests (one per room maximum, prioritize high-priority requests)
		if new_request_target > 0:
			var rooms_with_requests = []  # Track which rooms already have a request
			var selected_count = 0
			
			for request : Request in proposed:
				# Skip if this room already has a request selected
				if request.origin in rooms_with_requests:
					continue
				
				final_requests.append(request)
				rooms_with_requests.append(request.origin)
				selected_count += 1
				
				if selected_count >= new_request_target:
					break
		
		# Add back all surviving old requests
		for old_request in surviving_old_requests_by_type.get(room_type, []):
			final_requests.append(old_request)
	
	# ========== STEP 4: Apply new request list ==========
	hotel.buffered_requests = final_requests
	hotel.buffered_requests_flag = true
	new_request_cycle.emit()
	print("NEW REQUESTS!!!")
	print(final_requests)

