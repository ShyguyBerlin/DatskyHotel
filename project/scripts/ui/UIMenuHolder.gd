extends MarginContainer

signal menu_opened

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for c in get_children():
		c.visibility_changed.connect(child_visibility_changed.bind(c))

func child_visibility_changed(child):
	print("UI Visiblity changed to ",child.visible)
	if child.visible:
		for i in get_children():
			if i !=child:
				i.hide()
	check_mouse_mode()

func check_mouse_mode():
	var any_visible=false
	for i in get_children():
		if i.visible:
			any_visible=true
	if any_visible:
		mouse_filter=Control.MOUSE_FILTER_STOP
		menu_opened.emit()
	else:
		mouse_filter=Control.MOUSE_FILTER_IGNORE

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index==MOUSE_BUTTON_LEFT and event.is_pressed()==true:
		print("externally closing ui menus")
		close_menu()
	get_viewport().set_input_as_handled()

func close_menu():
	for c in get_children():
			c.hide()
