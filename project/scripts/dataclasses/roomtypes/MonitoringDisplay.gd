extends Node2D

@export var monitoring : MonitoringRoom

const menu_to_open = preload("uid://xqbljmnhixdq")

func get_dataclass_instance() -> MonitoringRoom:
	return monitoring

func set_dataclass_instance(new_model : MonitoringRoom):
	monitoring=new_model

func enter(input_data : Input_EnterRoomData):
	if not input_data or not input_data.room_view_menu:
		push_error("RoomViewMenu not provided to MonitoringDisplay.enter()")
		return
	var menu_instance = menu_to_open.instantiate()
	if menu_instance:
		input_data.room_view_menu.display_menu(menu_instance)
	else:
		push_error("Failed to instantiate MonitoringMenu in MonitoringDisplay.enter()")
