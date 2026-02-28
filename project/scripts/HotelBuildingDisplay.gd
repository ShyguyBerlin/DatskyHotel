@icon("res://Assets/Images/SVG/BuildIcon.svg")
extends HotelDisplay

const BLUEPRINT_ROOM = preload("uid://sc4ttc7r42q")
const BLUEPRINT_ROOM_CONNECTION = preload("uid://cxnolttfk712f")

static var room_horizontal_distance = -1
static var room_vertical_distance = -1

func _ready():
	super()
	if room_horizontal_distance == -1 or room_vertical_distance:
		var exampleRoom = Room.new()
		var exampleConnection = RoomConnection.new()
		room_horizontal_distance=exampleRoom.get_size(RoomConnection.display_direction.DISPLAY_RIGHT)+exampleConnection.get_size(RoomConnection.display_direction.DISPLAY_RIGHT)
		room_horizontal_distance=exampleRoom.get_size(RoomConnection.display_direction.DISPLAY_DOWN)+exampleConnection.get_size(RoomConnection.display_direction.DISPLAY_DOWN)

func draw_hotel():
	super()
	
	for i in display_nodes_folder.get_children():
		if not i.has_method("get_dataclass_instance") or not i.get_dataclass_instance() is Room:
			continue
		print(i.get_dataclass_instance().get_script().get_global_name())
		print(i.position)
