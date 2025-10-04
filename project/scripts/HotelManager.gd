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

func _process(delta: float) -> void:
	if not hotel_instance:
		return
	
	#Process Habitant needs and similar
	if not hotel_instance.register:
		hotel_instance.register=HabitantRegister.new()
	hotel_instance.register.process_habitants(delta)
