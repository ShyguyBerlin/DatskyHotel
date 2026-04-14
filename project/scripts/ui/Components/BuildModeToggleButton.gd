extends Button
## this used to do some showing/hiding on nodes, but that behavior is now covered by a Statemachine
## The purpose of the button now is to trigger the necessary transitions

@export var state_machine : StateMachine

@export var default_mode_state : StateMachineState
@export var build_mode_state : StateMachineState

func _ready():
	if not state_machine or not default_mode_state or not build_mode_state:
		printerr("Missing required export fields in BuildModeToggleButton")
		queue_free()
		return
	
	if default_mode_state.get_parent()!=state_machine:
		printerr("default state is not child of statemachine")
		return

	if build_mode_state.get_parent()!=state_machine:
		printerr("build state is not child of statemachine")
		return

	pressed.connect(toggle)

func toggle():
	match state_machine.get_current_state():
		default_mode_state:
			default_mode_state.transition.emit(default_mode_state,str(build_mode_state.name))
			return
		build_mode_state:
			build_mode_state.transition.emit(build_mode_state,default_mode_state.name)
			return
		_:
			return
