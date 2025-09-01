extends Room
class_name Residence

@export var resident : Habitant
func get_display_node():
	var display_node = load("res://nodes/roomtypes/Residence/ResidenceDisplay.tscn").instantiate()
	return display_node
