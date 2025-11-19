@tool
extends Control

@export var creation : bool = true : set = set_creation
@export var habitant : Habitant = null
var habitant_backup : Habitant = null
@onready var arrow_left: TextureButton = %ArrowLeft
@onready var arrow_right: TextureButton = %ArrowRight

@onready var habitant_display: HabitantDisplay = %HabitantDisplay
@onready var name_edit: LineEdit = %NameEdit

signal habitant_changes_confirmed(habitant: Habitant)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not habitant:
		habitant=Habitant.new()
	set_creation(creation)

func set_creation(should_be_in_create_mode : bool) -> void:
	creation=should_be_in_create_mode
	if not is_node_ready():
		return
	
	# Visible if creator, otherwise not
	var simple_flip_elements = [arrow_left, arrow_right]
	for i in simple_flip_elements:
		i.visible=creation

func set_habitant(template:Habitant):
	if template:
		habitant=template.duplicate()
		habitant_backup=habitant.duplicate()
		habitant_display.habitant=habitant
		name_edit.text=habitant.name
	else:
		habitant=null
		habitant_backup=null

func open_with_habitant(hab,creator):
	set_creation(creator)
	set_habitant(hab)
	open()

func on_cancel_button_pressed():
	habitant_changes_confirmed.emit(habitant_backup)
	hide()

func on_apply_button_pressed():
	habitant_changes_confirmed.emit(habitant)
	hide()

func open():
	visible=true

func change_habitant_name(new_text: String) -> void:
	habitant.name=new_text

func cycle_habitant_body(next:bool) -> void:
	var colors = [Color.BISQUE, Color.MEDIUM_AQUAMARINE, Color.DARK_GRAY, Color.LAVENDER_BLUSH, Color.PALE_VIOLET_RED]
	var cidx = 0
	while colors[cidx]!=habitant.body_color:
		cidx+=1
	if next:
		cidx+=1
	else:
		cidx+=colors.size()-1
	cidx%=len(colors)
	habitant.body_color=colors[cidx]
	habitant_display.update_display()
	print(cidx)
