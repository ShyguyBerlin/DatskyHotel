extends Room
class_name MonitoringRoom

# Shall return a node which displays the properties of this Resource
func get_display_node():
	return get_display_node_base("res://nodes/roomtypes/Monitoring/MonitoringDisplay.tscn")
