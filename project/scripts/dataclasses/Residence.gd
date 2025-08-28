extends Room
class_name Residence

@export var resident : Habitant
func get_display_node():
	var display_node = load("res://nodes/ResidenceDisplay.tscn").instantiate()
	return display_node
