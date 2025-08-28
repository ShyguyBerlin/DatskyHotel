extends Resource
class_name Hotel

var initial_room : Room

# Shall return a node which displays the properties of this Resource
func get_display_node():
	print(load("res://nodes/HotelDisplay.tscn"))
