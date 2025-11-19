extends Node2D

func _ready():
	visibility_changed.connect(on_visibility_changed)

func on_visibility_changed():
	if visible:
		get_parent().grab_focus()
