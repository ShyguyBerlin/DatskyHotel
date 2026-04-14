extends StateMachineState

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _enter():
	for child in get_children():
		if child.has_method("show"):
			child.show()

func _leave():
	for child in get_children():
		if child.has_method("hide"):
			child.hide()
