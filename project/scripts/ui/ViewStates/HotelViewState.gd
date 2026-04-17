extends StateMachineState

@export var sub_stm : StateMachine

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
	if sub_stm:
		sub_stm.current_state_node._enter()

func _leave():
	for child in get_children():
		if child.has_method("hide"):
			child.hide()
	if sub_stm:
		sub_stm.current_state_node._leave()
