extends Room
class_name Residence

@export var resident : Habitant

func get_display_node():
	return get_display_node_base("res://nodes/roomtypes/Residence/ResidenceDisplay.tscn")
