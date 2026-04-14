extends Node

@export var hotel_display_node : HotelDisplay
var current_room : Room = null
@onready var cycle_progress: ShaderArcMaskedSprite = %CycleProgress
@onready var cycle_progress2: ShaderArcMaskedSprite = %CycleProgress2

func _ready() -> void:
	
	
	TranslationServer.set_locale("en_en")
	
	
	var a = SaveSystem.save.hotel
	if SaveSystem.save.first_start:
		a.initial_room = MonitoringRoom.new()
		
		var b = Room.new()
		
		a.initial_room.connect_to_room(b,RoomConnection.display_direction.DISPLAY_RIGHT)
		
		var c = Room.new()
		
		b.connect_to_room(c,RoomConnection.display_direction.DISPLAY_RIGHT)

	HotelManager.hotel_instance=a
	if hotel_display_node:
		hotel_display_node.current_room=a.initial_room
	current_room = a.initial_room
	
	RequestManager.request_cycle_tick.connect(func(perc): cycle_progress.set("fill_percentage",perc))
	#RequestManager.new_request_cycle.connect(hotel_display_node.draw_hotel)

	GameTimeManager.MediumCycleProgress.connect(func(perc): cycle_progress2.set("fill_percentage",perc))
