extends Resource

@export var hotel: Hotel = Hotel.new() #HotelManager.hotel_instance

@export var player: Player = Player.new() #InputManager.player

@export var gametimecycles: Array[TimeCycle] #GameTimeManager.*_cycle

var first_start=true

func convert_to_ids():
	convert_room_connections_to_ids()
	convert_habitant_residence_to_id()
	convert_habitant_needs_to_id()

func convert_room_connections_to_ids():
	if hotel:
		var connections=[]
		var c=0
		for i in hotel.get_rooms():
			i.room_id=c
			c+=1
			
			for connection in i.connections:
				if not connection in connections:
					connections.append(connection)
		
		for i : RoomConnection in connections:
			var replacement={}
			for k in i.connected_rooms.keys():
				replacement[k.room_id]=i.connected_rooms[k]
			i.connected_rooms.clear()
			i.connected_rooms.assign(replacement)

func convert_habitant_residence_to_id():
	if hotel:
		if hotel.register:
			for i in hotel.register.habitants:
				i.residence=null # Nice ID dude

func convert_habitant_needs_to_id():
	if hotel:
		if hotel.register:
			for i in hotel.register.habitants:
				for n in i.needs:
					n.habitant=null # Nice ID still

func convert_to_refs():
	convert_room_connections_to_refs()
	convert_habitant_residence_to_refs()
	convert_habitant_needs_to_refs()

func convert_room_connections_to_refs():
	if hotel:
		var rooms = hotel.__rooms
		rooms.sort_custom(func(x,y): return x.room_id<y.room_id)
		var connections=[]
		for i in rooms:
			for connection in i.connections:
				if not connection in connections:
					connections.append(connection)
		for i : RoomConnection in connections:
			var replacement={}
			for k in i.connected_rooms.keys():
				replacement[rooms[k]]=i.connected_rooms[k]
			i.connected_rooms.clear()
			i.connected_rooms.assign(replacement)

func convert_habitant_residence_to_refs():
	if hotel:
		for i in hotel.__rooms:
			if not i is Residence:
				continue
			i = i as Residence
			if i.resident:
				i.resident.residence=i

func convert_habitant_needs_to_refs():
	if hotel:
		if hotel.register:
			for i in hotel.register.habitants:
				for n in i.needs:
					n.habitant=i
