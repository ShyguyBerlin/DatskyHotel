extends Node2D

@export var monitoring : MonitoringRoom

func get_dataclass_instance() -> MonitoringRoom:
	return monitoring

func set_dataclass_instance(new_model : MonitoringRoom):
	monitoring=new_model

func enter(input_data : Input_EnterRoomData):
	if not input_data:
		push_error("input_data not provided to MonitoringDisplay.enter()")
		return
	input_data.open_room_view_menu=true
