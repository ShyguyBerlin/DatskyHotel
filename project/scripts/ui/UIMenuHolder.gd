extends MarginContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for c in get_children():
		c.visibility_changed.connect(child_visibility_changed.bind(c))

func child_visibility_changed(child):
	print("UI Visiblity changed to ",child.visible)
	if child.visible:
		mouse_filter=Control.MOUSE_FILTER_STOP
	else:
		mouse_filter=Control.MOUSE_FILTER_IGNORE

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		close_menu()
	get_viewport().set_input_as_handled()

func close_menu():
	for c in get_children():
			c.hide()
