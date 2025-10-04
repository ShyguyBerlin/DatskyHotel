extends Resource
class_name RoomConnection

# Room -> display_direction
var connected_rooms : Dictionary

enum display_direction{
	DISPLAY_LEFT = 0,
	DISPLAY_RIGHT = 1,
	DISPLAY_DOWN = 2,
	DISPLAY_UP = 3
}

static func get_display_direction_vector(direction:display_direction) -> Vector2i:
	if direction==display_direction.DISPLAY_LEFT:
		return Vector2i(-1,0)
	if direction==display_direction.DISPLAY_RIGHT:
		return Vector2i(1,0)
	if direction==display_direction.DISPLAY_UP:
		return Vector2i(0,-1)
	if direction==display_direction.DISPLAY_DOWN:
		return Vector2i(0,1)
	return Vector2i(0,0)

static func is_direction_horizontal(direction:display_direction) -> bool:
	if direction==display_direction.DISPLAY_LEFT:
		return true
	if direction==display_direction.DISPLAY_RIGHT:
		return true
	if direction==display_direction.DISPLAY_UP:
		return false
	if direction==display_direction.DISPLAY_DOWN:
		return false
	return false

static func invert_display_direction(direction:display_direction) -> display_direction:
	if direction==display_direction.DISPLAY_LEFT:
		return display_direction.DISPLAY_RIGHT
	if direction==display_direction.DISPLAY_RIGHT:
		return display_direction.DISPLAY_LEFT
	if direction==display_direction.DISPLAY_UP:
		return display_direction.DISPLAY_DOWN
	if direction==display_direction.DISPLAY_DOWN:
		return display_direction.DISPLAY_UP
	return display_direction.DISPLAY_UP

###################################################
#########   Display related functions #############
###################################################

# Shall return a node which displays the properties of this Resource
func get_display_node():
	var display_node = load("res://nodes/RoomConnectionDisplay.tscn").instantiate()
	display_node.set_dataclass_instance(self)
	return display_node

func get_size(direction : display_direction) -> Vector2:
	match(direction):
		display_direction.DISPLAY_LEFT:
			return Vector2(-30,0)
		display_direction.DISPLAY_RIGHT:
			return Vector2(30,0)
		display_direction.DISPLAY_UP:
			return Vector2(0,-20)
		display_direction.DISPLAY_DOWN:
			return Vector2(0,20) # vertical display size
	return Vector2(0,0)

###################################################
#########   Display related functions end #########
###################################################
