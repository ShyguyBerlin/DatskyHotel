extends Control
class_name RoomViewMenu

func display_menu(menu : Control):
	# Clear existing children
	for child in get_children():
		remove_child(child)
		child.queue_free()
	
	add_child(menu)
	if not menu.has_method("open"):
		push_warning("Menu to open with RoomViewMenu should have open() implemented")
		menu.show()
	else:
		menu.open()
	show()
	

func _on_child_entered_tree(node: Node) -> void:
	node.visibility_changed.connect(child_visibility_changed.bind(node))

func child_visibility_changed(node : Node) -> void:
	if node.visible==false:
		remove_child(node)
		node.queue_free()
		hide()