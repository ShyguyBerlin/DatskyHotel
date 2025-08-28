extends Node

var hotel_instance : Hotel = null : set = set_hotel_instance

signal kill_hotel_instance_event
signal set_hotel_instance_event

func is_hotel_instanced():
	return hotel_instance==null

func set_hotel_instance(new_instance):
	if hotel_instance:
		kill_hotel_instance_event.emit()
	hotel_instance=new_instance
	set_hotel_instance_event.emit()
