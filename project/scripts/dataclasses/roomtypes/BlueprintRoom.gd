extends Node2D

signal pressed
@onready var button: Button = %Button
@export var clickable = true : set = set_clickable

func _ready() -> void:
	button.pressed.connect(clicked)

func set_clickable(new_val):
	clickable=new_val
	button.disabled=not clickable

func clicked():
	if clickable:
		pressed.emit()
