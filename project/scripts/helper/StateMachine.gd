extends Node
class_name StateMachine

@export var current_state : int = 0
var current_state_node : StateMachineState = null
var states : Dictionary = {}

func _ready():
	var children = get_children()
	for i in range(len(children)):
		var child = children[i]
		if not child is StateMachineState:
			push_warning("StateMachine generally expects children to be StateMachineState. Other nodes might lead to weird behavior.")
		else:
			child = child as StateMachineState
			child.transition.connect(_on_child_transition)
			states[child.name] = i
	enter_state_id(current_state)

func get_current_state() -> StateMachineState:
	return current_state_node

func enter_state(name : String):
	if not name in states:
		printerr("tried to enter state by name that isnt registered: \"",name,"\"")
		return
	enter_state_id(states[name])

func enter_state_id(id : int):
	if not id in states.values():
		printerr("this should not even be worth an error log: Tried to enter a state that isnt a state.")
		return
	_enter_state(get_child(id))
	current_state=id

func _enter_state(state : StateMachineState):
	if current_state_node:
		current_state_node.__leave()
	state.__enter()
	current_state_node=state

func _on_child_transition(origin_state : StateMachineState, target_state : String):
	if origin_state!= current_state_node:
		printerr("A child state tried to transition, while it was not the active state. Transition was ",origin_state.name," -> ",target_state)
		return
	enter_state(target_state)
