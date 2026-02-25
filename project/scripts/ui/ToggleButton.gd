@tool
extends Button
class_name ToggleButton

signal toggle_state_changed(toggled_on : bool)

# Determines whether the boolean state is currently off or on
@export var is_toggled : bool = false : set= set_is_toggled
@export var marker_icon : Texture2D : set=set_marker_icon
@export var marker_icon_margin : int : set=set_marker_icon_margin
@export var use_theme_margins : bool : set=set_use_theme_margins

@onready var margin_container: MarginContainer = %MarginContainer
@onready var marker_texture: TextureRect = %MarkerTexture

func set_is_toggled(new_bool):
	is_toggled=new_bool
	redraw()

func set_marker_icon(new_icon : Texture2D):
	marker_icon = new_icon
	redraw()

func set_marker_icon_margin(new_margin : int):
	marker_icon_margin =new_margin
	redraw()

func set_use_theme_margins(new_bool):
	use_theme_margins=new_bool
	redraw()

func redraw():
	if not is_node_ready():
		return
	if use_theme_margins:
		margin_container.remove_theme_constant_override("margin_bottom")
		margin_container.remove_theme_constant_override("margin_left")
		margin_container.remove_theme_constant_override("margin_right")
		margin_container.remove_theme_constant_override("margin_top")
	else:
		margin_container.add_theme_constant_override("margin_bottom",marker_icon_margin)
		margin_container.add_theme_constant_override("margin_left",marker_icon_margin)
		margin_container.add_theme_constant_override("margin_right",marker_icon_margin)
		margin_container.add_theme_constant_override("margin_top",marker_icon_margin)
	marker_texture.texture=marker_icon
	marker_texture.visible=is_toggled

func _ready():
	redraw()

func _on_pressed() -> void:
	set_is_toggled(not is_toggled)
	toggle_state_changed.emit(is_toggled)
