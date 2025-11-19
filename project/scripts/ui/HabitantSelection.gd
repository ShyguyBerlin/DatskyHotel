@tool
extends Control

@export var register:HabitantRegister : set = set_register

@onready var habitant_list: Panel = %HabitantList
@onready var habitant_name_panel: Panel = %HabitantNamePanel
@onready var habitant_name_label: RichTextLabel = %HabitantNameLabel
@onready var habitant_display: HabitantDisplay = %HabitantDisplay
@onready var edit_button_panel: Panel = %EditPanel

var currently_selected_habitant : int=-1

signal selected_habitant(habitant:Habitant)
signal open_habitant_creator(habitant_to_edit:Habitant,create_mode:bool)

func _ready() -> void:
	populate_habitant_list()
	draw_selected_habitant()

func set_register(reg:HabitantRegister):
	register=reg
	currently_selected_habitant=-1
	populate_habitant_list()

func populate_habitant_list():
	if not is_node_ready():
		return
	habitant_list.clear()
	
	if not register:
		return
	
	for i in register.habitants:
		var rtext=""
		if not i.residence:
			rtext="no room"
		habitant_list.add_item(i.name,rtext)

func draw_selected_habitant() -> void:
	if currently_selected_habitant!=-1:
		habitant_name_panel.show()
		habitant_display.habitant=register.habitants[currently_selected_habitant]
		habitant_display.update_display()
		habitant_display.show()
		habitant_name_label.text=register.habitants[currently_selected_habitant].name
		edit_button_panel.show()
	else:
		habitant_name_panel.hide()
		habitant_display.hide()
		edit_button_panel.hide()

func add_habitant_button_pressed():
	if not register:
		print("No register set")
		return
	var new_habitant=Habitant.new()
	var possible_names=["Alice","Bob","Charlie","Dora","Eric","Foo","Greg","Historia","Imyr","John","Kirk","Louis","Minato","Nugget","Omar","Popeye","Rhaast"]
	new_habitant.name=possible_names.pick_random()
	var colors = [Color.BISQUE,Color.MEDIUM_AQUAMARINE,Color.DARK_GRAY,Color.LAVENDER_BLUSH,Color.PALE_VIOLET_RED]
	new_habitant.body_color=colors[randi_range(0,len(colors)-1)]
	
	var food_need = preload("uid://dqew5h564cmig").new()
	new_habitant.add_need(food_need)
	
	register.register_habitant(new_habitant)
	populate_habitant_list()
	habitant_list.selected_item(register.habitants.size()-1)
	draw_selected_habitant()
	open_habitant_creator.emit(new_habitant,true)
	hide()

func habitant_selected(idx:int):
	if idx==currently_selected_habitant:
		habitant_selected_final(idx)
		return
	currently_selected_habitant=idx
	draw_selected_habitant()

func habitant_selected_final(idx:int):
	hide()
	selected_habitant.emit(register.habitants[idx])

func on_edit_button_pressed():
	if currently_selected_habitant==-1:
		return
	var hab= register.habitants[currently_selected_habitant]
	open_habitant_creator.emit(hab,false)
	hide()

# From creator data, should only overwrite fields which the creator can edit
func overwrite_current_habitant(habitant: Habitant):
	register.habitants[currently_selected_habitant].name=habitant.name
	register.habitants[currently_selected_habitant].bodytype=habitant.bodytype
	register.habitants[currently_selected_habitant].body_color=habitant.body_color
