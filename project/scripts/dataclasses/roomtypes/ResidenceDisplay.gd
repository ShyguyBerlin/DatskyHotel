extends Node2D

@export var residence : Residence

func get_dataclass_instance() -> Residence:
	return residence

func set_dataclass_instance(new_model : Residence):
	residence=new_model
	draw_inhabitant()

func _draw():
	draw_inhabitant()

func draw_inhabitant():
	pass
