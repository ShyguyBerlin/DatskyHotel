extends Room
class_name Elevator

# Shall return a node which displays the properties of this Resource
func get_display_node():
	return get_display_node_base("res://nodes/roomtypes/Elevator/ElevatorDisplay.tscn")
