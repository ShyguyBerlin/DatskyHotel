extends Node

@export var player_instance : Player
@export var hotel_display_node : HotelDisplay
@export var builder_node : HotelBuilder
var spatial_room_finder : HotelSpatialRoomFinder

func _ready() -> void:
	if SaveSystem.save:
		player_instance=SaveSystem.save.player
	else:
		printerr("Could not find player instance for BuildModeInputHandler")

func set_spatial_room_finder(room_finder: HotelSpatialRoomFinder) -> void:
	spatial_room_finder=room_finder

func _unhandled_input(event: InputEvent) -> void:
	if not hotel_display_node.visible:
		return
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		print("LEFT MOUSE CLICK")
		var mouse_pos=get_viewport().get_mouse_position()
		mouse_pos-=hotel_display_node.global_position
		mouse_pos=Vector2(mouse_pos.x/hotel_display_node.scale.x,mouse_pos.y/hotel_display_node.scale.y)
		var adjusted_mouse_pos=mouse_pos-hotel_display_node.current_offset
		if not spatial_room_finder:
			print("no room finder configured")
			return
		var rooms = spatial_room_finder.find_room(adjusted_mouse_pos)
		if len(rooms)>0:
			var room_instance=rooms[0].get_dataclass_instance()
			if room_instance:
				hotel_display_node.current_room=room_instance
			get_viewport().set_input_as_handled()
			print("Swapped current room")
			return
		hotel_display_node.current_room=null
		get_viewport().set_input_as_handled()
		print("Deselected any room")
		return
