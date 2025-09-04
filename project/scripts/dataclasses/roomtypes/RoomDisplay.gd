extends Node2D

@export var room : Room

func get_dataclass_instance() -> Room:
	return room

func set_dataclass_instance(new_model : Room):
	room=new_model
