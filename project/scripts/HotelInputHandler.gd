extends Node
class_name HotelInputManager

@export var player_instance : Player
@export var hotel_display_node : HotelDisplay
@export var builder_node : HotelBuilder
@export var habitant_selection: Control
@export var gift_menu : Control
@export var money_label : RichTextLabel
@export var shop: Control
var spatial_room_finder : HotelSpatialRoomFinder

func _ready() -> void:
	if SaveSystem.save.first_start:
		SaveSystem.save.player=player_instance
	else:
		player_instance=SaveSystem.save.player
		
	if player_instance:
		player_instance.money_changed.connect(player_money_changed)
		if money_label:
			money_label.set_target_value(player_instance.money,true)
		shop.inventory_holder=player_instance

func set_spatial_room_finder(room_finder: HotelSpatialRoomFinder) -> void:
	spatial_room_finder=room_finder

func move_dir(dir : RoomConnection.display_direction):
	if not hotel_display_node:
		return
	
	# connection which lies in the given direction
	var connection_passing=null
	var croom : Room = hotel_display_node.current_room
	
	if not croom:
		return
	
	# find connection, which points to the current room in the inverted direction
	for i in croom.connections:
		var croom_to_dir = i.connected_rooms.get(croom)
		if croom_to_dir != null and croom_to_dir == RoomConnection.invert_display_direction(dir):
			connection_passing=i
			break
	
	if not connection_passing:
		return
	
	# find a room which is in the correct direction
	for i in connection_passing.connected_rooms.keys():
		if connection_passing.connected_rooms.get(i)==dir:
			hotel_display_node.current_room=i
			return

func move_left():
	return move_dir(RoomConnection.display_direction.DISPLAY_LEFT)

func move_right():
	return move_dir(RoomConnection.display_direction.DISPLAY_RIGHT)

func move_up():
	return move_dir(RoomConnection.display_direction.DISPLAY_UP)

func move_down():
	return move_dir(RoomConnection.display_direction.DISPLAY_DOWN)

func unselect_room():
	if not hotel_display_node:
		return
	hotel_display_node.current_room=null

func select_initial_room():
	if not hotel_display_node:
		return
	hotel_display_node.current_room=HotelManager.hotel_instance.initial_room

func before_build():
	builder_node.current_room=hotel_display_node.current_room

func build_residence():
	if not builder_node:
		return
	before_build()
	return builder_node.make_room_to_residence()

func build_elevator():
	if not builder_node:
		return
	before_build()
	return builder_node.make_room_to_elevator()


func build_room_left():
	if not builder_node:
		return
	before_build()
	return builder_node.build_room_to_left()

func build_room_right():
	if not builder_node:
		return
	before_build()
	return builder_node.build_room_to_right()

func build_room_down():
	if not builder_node:
		return
	before_build()
	return builder_node.build_room_to_down()

func build_room_up():
	if not builder_node:
		return
	before_build()
	return builder_node.build_room_to_up()

func select_habitant_to_reside():
	if not habitant_selection:
		return
	habitant_selection.register=HotelManager.hotel_instance.register
	habitant_selection.open()

func enter_residence():
	if not hotel_display_node.current_room:
		return
	
	var residence=hotel_display_node.current_room
	if not residence is Residence:
		return
	
	var tk_action=TalkAction.new()
	tk_action.player=player_instance
	tk_action.display_node=hotel_display_node.get_current_display_node()
	residence.consume_talk_action(tk_action)

func select_habitant_to_reside_finish(habitant_selected:Habitant):
	
	if not hotel_display_node.current_room:
		print("No room selected")
		return
	
	if not hotel_display_node.current_room is Residence:
		if hotel_display_node.get_script():
			printerr("Trying to move a resident to a non-residence room",hotel_display_node.current_room.get_script().get_global_name())
			return
		else:
			printerr("Trying to move a resident to a non-residence room of unknown type")
			return
	
	if habitant_selected.residence:
		habitant_selected.residence.resident=null
	if hotel_display_node.current_room.resident:
		hotel_display_node.current_room.resident.residence=null
	
	habitant_selected.residence=hotel_display_node.current_room
	hotel_display_node.current_room.resident=habitant_selected

func open_gift_menu():
	if not gift_menu:
		return
	if not gift_menu.has_method("open"):
		return
	if not hotel_display_node.current_room.resident:
		return
	gift_menu.open(player_instance)

func finished_gift_menu(item_name: String) -> void:
	if not hotel_display_node.current_room is Residence or hotel_display_node.current_room.resident==null:
		return
	if not item_name in player_instance.inventory:
		return
	if player_instance.inventory[item_name]<=0:
		player_instance.inventory.erase(item_name)
		return
	player_instance.inventory[item_name]-=1
	if player_instance.inventory[item_name]<=0:
		player_instance.inventory.erase(item_name)
	var gift_action = GiftAction.new(item_name)
	gift_action.player=player_instance
	gift_action.display_node = hotel_display_node.get_current_display_node()
	if hotel_display_node.get_current_display_node():
		hotel_display_node.get_current_display_node().queue_redraw()
	hotel_display_node.current_room.resident.recieve_gift(gift_action)

func player_money_changed():
	if money_label and player_instance:
		money_label.set_target_value(player_instance.money)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("hotel_move_left"):
		move_left()
	if event.is_action_pressed("hotel_move_right"):
		move_right()
	if event.is_action_pressed("hotel_move_up"):
		move_up()
	if event.is_action_pressed("hotel_move_down"):
		move_down()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		print("LEFT MOUSE CLICK")
		var mouse_pos=get_viewport().get_mouse_position()
		mouse_pos-=hotel_display_node.global_position
		mouse_pos=Vector2(mouse_pos.x/hotel_display_node.scale.x,mouse_pos.y/hotel_display_node.scale.y)
		var adjusted_mouse_pos=mouse_pos-hotel_display_node.current_offset
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
