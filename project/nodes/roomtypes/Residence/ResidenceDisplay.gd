extends Node2D

@export var residence : Residence

func take_model(new_model : Residence):
	residence=new_model
	draw_inhabitant()

func _draw():
	draw_inhabitant()

func draw_inhabitant():
	pass
