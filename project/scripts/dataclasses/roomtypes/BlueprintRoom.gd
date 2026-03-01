@tool
extends Node2D
class_name BlueprintRoomConnection

signal pressed
@onready var button: Button = %Button
@export var clickable = true : set = set_clickable
@export var direction : RoomConnection.display_direction : set=set_direction
@export var no_arrow : bool = false

var origin_room : Room
var connecting_to : Room#Set to null if building new room

@onready var arrow_left: Panel = %ArrowLeft
@onready var arrow_up: Panel = %ArrowUp
@onready var arrow_down: Panel = %ArrowDown
@onready var arrow_right: Panel = %ArrowRight
@onready var horizontal_panel: Panel = %HorizontalPanel
@onready var vertical_panel: Panel = %VerticalPanel

func _ready() -> void:
	button.pressed.connect(clicked)
	set_direction(direction)

func set_clickable(new_val):
	clickable=new_val
	if button:
		button.disabled=not clickable

func set_direction(dir : RoomConnection.display_direction):
	direction=dir
	if not horizontal_panel or not vertical_panel:
		return
	horizontal_panel.visible=false
	vertical_panel.visible=false
	arrow_down.visible=false
	arrow_up.visible=false
	arrow_left.visible=false
	arrow_right.visible=false
	match(direction):
		RoomConnection.display_direction.DISPLAY_DOWN:
			vertical_panel.show()
			arrow_down.show()
		RoomConnection.display_direction.DISPLAY_UP:
			vertical_panel.show()
			arrow_up.show()
		RoomConnection.display_direction.DISPLAY_LEFT:
			horizontal_panel.show()
			arrow_left.show()
		RoomConnection.display_direction.DISPLAY_RIGHT:
			horizontal_panel.show()
			arrow_right.show()
	if no_arrow:
		arrow_down.visible=false
		arrow_up.visible=false
		arrow_left.visible=false
		arrow_right.visible=false

func clicked():
	if clickable:
		pressed.emit()
