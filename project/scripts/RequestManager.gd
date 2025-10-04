extends Node

const TIME_BETWEEN_CYCLES=20
var timer=TIME_BETWEEN_CYCLES

signal request_cycle_tick(percentage:float)
signal new_request_cycle()

func _process(delta: float) -> void:
	timer-=delta
	request_cycle_tick.emit((TIME_BETWEEN_CYCLES-timer)/TIME_BETWEEN_CYCLES)
	if timer<0:
		timer=TIME_BETWEEN_CYCLES
		perform_request_cycle(HotelManager.hotel_instance)

func perform_request_cycle(hotel:Hotel=null) -> void:
	if hotel==null:
		hotel=HotelManager.hotel_instance
	if hotel==null:
		return
	
	var rooms : Array[Room]=hotel.get_rooms()
	var hotel_size=len(rooms)
	
	# Maps Room type to list of requests for this room type
	var proposed_requests={}
	
	# Figure out how much of each kind of room there is in the hotel
	var room_quantities={}
	for i : Room in rooms:
		if not i.get_script().get_global_name() in proposed_requests:
			proposed_requests[i.get_script().get_global_name()]=[]
			room_quantities[i.get_script().get_global_name()]=0
		proposed_requests[i.get_script().get_global_name()].append_array(i.generate_request())
		room_quantities[i.get_script().get_global_name()]+=1
	
	# Keep some of the old quests, also sort them by room type
	var old_requests={}
	for i in hotel.requests:
		var survival_chance=i.priority*0.06
		if randf()<survival_chance:
			if not i.origin.get_script().get_global_name() in old_requests:
				old_requests[i.origin.get_script().get_global_name()]=[]
			old_requests[i.origin.get_script().get_global_name()].append(i)
	hotel.requests.clear()

	var new_requests: Array[Request]=[]
	# pick a few quests per room type, according to the formula in target_quantity
	for c in proposed_requests.keys():
		var type_quantity=room_quantities[c]
		
		var target_quantity_min
		var target_quantity_max
		if c=="Residence": # This might need a better way if we add more residency types
			if type_quantity<=3:
				target_quantity_max=round(type_quantity)
			elif type_quantity<=10:
				target_quantity_max=round(2./5.*type_quantity+1.8)
			else:
				target_quantity_max=round(sqrt(type_quantity+10)+1.4)
			target_quantity_min=round(sqrt(type_quantity*0.6+3)-1)
		else:
			target_quantity_max=round(sqrt(type_quantity*0.6+3)-1)
			target_quantity_min=0
		
		var target = randi_range(target_quantity_min,target_quantity_max)-len(old_requests.get_or_add(c,[]))
		if target<0:
			target=0
		
		if target==0:
			continue
		#proposed requests for this room type
		print("requests")
		print(proposed_requests)
		print(proposed_requests[c])
		var preqs : Array=proposed_requests[c]
		preqs = preqs as Array[Request]
		preqs.shuffle()
		preqs.sort_custom(func(a,b): a.priority>b.priority)
		var banned_rooms=[]
		var accepted=0
		for req :Request in preqs:
			if req.origin in banned_rooms:
				continue
			new_requests.append(req)
			banned_rooms.append(req.origin)
			req.accept()
			accepted+=1
			if accepted==target:
				break
	hotel.requests=new_requests
	new_request_cycle.emit()
	print("NEW REQUESTS!!!")
