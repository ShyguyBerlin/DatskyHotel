extends Node
class_name StateMachineState

signal entered
signal left
signal transition(origin:StateMachineState, target:String)

# Do not override
func __enter():
	_enter()
	entered.emit()

func _enter():
	pass

# Do not override
func __leave():
	_leave()
	left.emit()

func _leave():
	pass
