extends Control

func _ready():
	var child :TouchScreenButton = get_child(0)
	if child.texture_normal:
		position = -child.texture_normal.get_size()/2
