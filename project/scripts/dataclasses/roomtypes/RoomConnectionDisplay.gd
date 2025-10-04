extends Node2D

# The dataclass instance this display node represents
@export var room_connection : RoomConnection

@onready var horizontal_line: Line2D = %HorizontalLine
@onready var vertical_line: Line2D = %VerticalLine

# Returns the dataclass instance associated with this display node
func get_dataclass_instance() -> RoomConnection:
	return room_connection

# Sets the dataclass instance for this display node
func set_dataclass_instance(new_model : RoomConnection):
	room_connection = new_model
	# Call any update methods here
	if is_node_ready():
		update_display()

# Override this method to update the visual representation
func update_display():
	# Add your display update logic here
	if not room_connection:
		return
	# has horizontal connection
	if RoomConnection.display_direction.DISPLAY_LEFT in room_connection.connected_rooms.values() or  RoomConnection.display_direction.DISPLAY_RIGHT in room_connection.connected_rooms.values():
		horizontal_line.show()
	else:
		horizontal_line.hide()
	# has vertical connection
	if RoomConnection.display_direction.DISPLAY_UP in room_connection.connected_rooms.values() or  RoomConnection.display_direction.DISPLAY_DOWN in room_connection.connected_rooms.values():
		vertical_line.show()
	else:
		vertical_line.hide()

# Optional: Override _ready() to initialize display
func _ready():
	if room_connection:
		update_display()
