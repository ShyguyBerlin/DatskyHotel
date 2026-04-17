extends Button

@export var my_state : StateMachineState
@export var target_state : StateMachineState

func _ready() -> void:
	pressed.connect(_on_press)

func _on_press():
	my_state.transition.emit(my_state,target_state.name)
