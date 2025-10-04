@tool
extends Control

@export var register:HabitantRegister : set = set_register

@onready var habitant_list: ItemList = %HabitantList

signal selected_habitant(habitant:Habitant)

func _ready() -> void:
	populate_habitant_list()

func set_register(reg:HabitantRegister):
	register=reg
	populate_habitant_list()

func populate_habitant_list():
	if not is_node_ready():
		return
	habitant_list.clear()
	
	if not register:
		return
	
	for i in register.habitants:
		habitant_list.add_item(i.name)

func add_habitant_button_pressed():
	if not register:
		print("No register set")
		return
	var new_habitant=Habitant.new()
	new_habitant.name="Bob"
	var colors = [Color.BISQUE,Color.MEDIUM_AQUAMARINE,Color.DARK_GRAY,Color.LAVENDER_BLUSH,Color.PALE_VIOLET_RED]
	new_habitant.body_color=colors[randi_range(0,len(colors)-1)]
	
	var food_need = preload("uid://dqew5h564cmig").new()
	new_habitant.add_need(food_need)
	
	register.register_habitant(new_habitant)
	populate_habitant_list()

func habitant_selected(idx:int):
	hide()
	selected_habitant.emit(register.habitants[idx])
