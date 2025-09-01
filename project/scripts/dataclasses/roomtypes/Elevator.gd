extends Room
class_name Elevator

# Shall return a node which displays the properties of this Resource
func get_display_node():
	var display_node = load("res://nodes/roomtypes/Elevator/ElevatorDisplay.tscn").instantiate()
	return display_node
