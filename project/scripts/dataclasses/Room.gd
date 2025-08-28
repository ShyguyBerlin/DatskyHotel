extends Resource
class_name Room

var connections : Array[RoomConnection]

func connect_to_room(room : Room,direction : RoomConnection.display_direction):
	var new_connection = RoomConnection.new()
	
	new_connection.connected_rooms.set(self,RoomConnection.invert_display_direction(direction))
	new_connection.connected_rooms.set(room,direction)

	connections.append(new_connection)
	room.connections.append(new_connection)

func get_rooms_in_direction(direction : RoomConnection.display_direction) -> Array[Room]:
	
	var cons : Array[RoomConnection] = connections
	var dircons : Array[RoomConnection] = []
	for i in cons:
		if i.connected_rooms.get(self)==RoomConnection.invert_display_direction(direction):
			dircons.append(i)
	
	var rooms : Array[Room]= []
	for dircon in dircons:
		for cr in dircon.connected_rooms.keys():
			if dircon.connected_rooms.get(cr)==direction:
				rooms.append(cr)
	return rooms

###################################################
#########   Display related functions #############
###################################################

# Shall return a node which displays the properties of this Resource
func get_display_node():
	var display_node = load("res://nodes/RoomDisplay.tscn").instantiate()
	return display_node

func get_size(direction : RoomConnection.display_direction) -> Vector2:
	match(direction):
		RoomConnection.display_direction.DISPLAY_LEFT:
			return Vector2(-80,0)
		RoomConnection.display_direction.DISPLAY_RIGHT:
			return Vector2(80,0)
		RoomConnection.display_direction.DISPLAY_UP:
			return Vector2(0,-60)
		RoomConnection.display_direction.DISPLAY_DOWN:
			return Vector2(0,60) # vertical display size
	return Vector2(0,0)

###################################################
#########   Display related functions end #########
###################################################
