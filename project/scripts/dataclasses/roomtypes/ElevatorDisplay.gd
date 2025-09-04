extends Node2D

@export var elevator : Elevator

func get_dataclass_instance() -> Elevator:
	return elevator

func set_dataclass_instance(new_model : Elevator):
	elevator=new_model
