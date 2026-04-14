extends Node

@export var player_instance : Player
@export var hotel_display_node : HotelDisplay
@export var builder_node : HotelBuilder
var spatial_room_finder : HotelSpatialRoomFinder
signal try_room_upgrade(room : Room)

func _ready() -> void:
	hotel_display_node.try_upgrade_room.connect(_on_upgrade_button_pressed)
	if SaveSystem.save:
		player_instance=SaveSystem.save.player
	else:
		printerr("Could not find player instance for BuildModeInputHandler")

func set_spatial_room_finder(room_finder: HotelSpatialRoomFinder) -> void:
	spatial_room_finder=room_finder

func _unhandled_input(event: InputEvent) -> void:
	if not hotel_display_node.is_visible_in_tree():
		return
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
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
			return
		hotel_display_node.current_room=null
		get_viewport().set_input_as_handled()
		return

func has_cost(cost) -> bool:
	if player_instance.money>=cost:
		player_instance.money-=cost
	else:
		print("Not enough money")
		return false
	return true

func _on_build_hotel_blueprint_construction(blueprint: BlueprintRoomConnection) -> void:
	var cost=10
	if blueprint.connecting_to==null:
		cost+=RoomUpgradeMenu.room_costs.get(Room)
	
	if not has_cost(cost):
		return
	
	builder_node.current_room=blueprint.origin_room
	
	var new_room
	if blueprint.connecting_to==null:
		new_room=Room.new()
		builder_node.build_room_in_dir(blueprint.direction,new_room)
	else:
		blueprint.origin_room.connect_to_room(blueprint.connecting_to,blueprint.direction)
		builder_node.built_stuff.emit()
		new_room=blueprint.origin_room
	hotel_display_node.current_room=new_room
	hotel_display_node.center_around_node(blueprint,false)

var last_selected_room : Room
func _on_upgrade_button_pressed(room:Room):
	last_selected_room = room
	try_room_upgrade.emit(room)

func _on_build_hotel_room_upgrade(upgrade_type:Script):
	var room = last_selected_room
	var cost=0
	cost+=RoomUpgradeMenu.room_costs.get(upgrade_type)
	if room.get_script():
		cost-=RoomUpgradeMenu.room_costs.get(room.get_script())
	if not has_cost(cost):
		return
	
	builder_node.current_room=room
	builder_node.make_room_to_else(upgrade_type)
