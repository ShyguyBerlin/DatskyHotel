@icon("res://Assets/Images/SVG/BuildIcon.svg")
extends HotelDisplay

const BLUEPRINT_ROOM = preload("uid://sc4ttc7r42q")
const BLUEPRINT_ROOM_CONNECTION = preload("uid://cxnolttfk712f")

static var room_distance:Vector2 = Vector2.INF

signal blueprint_construction(blueprint : BlueprintRoomConnection)
signal try_upgrade_room(room : Room)
var selected_blueprint : BlueprintRoomConnection

@onready var button_scaler: Control = %ButtonScaler
@onready var accept: Button = %Accept
@onready var cancel: Button = %Cancel
@onready var upgrade: Button = %Upgrade

func _ready():
	if room_distance == Vector2.INF:
		var exampleRoom = Room.new()
		var exampleConnection = RoomConnection.new()
		room_distance=Vector2(
			exampleRoom.get_size(RoomConnection.display_direction.DISPLAY_RIGHT).x+exampleConnection.get_size(RoomConnection.display_direction.DISPLAY_RIGHT).x,
			exampleRoom.get_size(RoomConnection.display_direction.DISPLAY_DOWN).y+exampleConnection.get_size(RoomConnection.display_direction.DISPLAY_DOWN).y
			)
	super()

func change_current_room(new_room):
	if new_room:
		if new_room.get_script() and new_room.get_script() in RoomUpgradeMenu.upgrade_tree:
			button_scaler_upgrade()
		else:
			button_scaler_none()
	super(new_room)

func draw_hotel():
	super()
	
	for i in display_nodes_folder.get_children():
		var obj = i.get_dataclass_instance()
		if not i.has_method("get_dataclass_instance") or not obj is Room:
			continue
		print(obj.get_script().get_global_name())
		print(i.position)
		
		var found_rooms
		var dirs
		
		# Check left and right
		dirs = [RoomConnection.display_direction.DISPLAY_RIGHT,RoomConnection.display_direction.DISPLAY_LEFT]
		for d in dirs:
			found_rooms = _room_finder.find_room(i.position+room_distance*Vector2(RoomConnection.get_display_direction_vector(d)))
			if found_rooms.is_empty():
				add_blueprint_directional(d, i.position, obj)
			elif d==RoomConnection.display_direction.DISPLAY_RIGHT:
				if not obj.is_connected_to(found_rooms[0].get_dataclass_instance(),1):
					add_blueprint_connecting(d,i.position, obj, found_rooms[0].get_dataclass_instance())

		dirs = [RoomConnection.display_direction.DISPLAY_DOWN,RoomConnection.display_direction.DISPLAY_UP]
		if i.get_dataclass_instance() is Elevator:
			for d in dirs:
				found_rooms = _room_finder.find_room(i.position+room_distance*Vector2(RoomConnection.get_display_direction_vector(d)))
				if found_rooms.is_empty():
					add_blueprint_directional(d,i.position, obj)
				elif d==RoomConnection.display_direction.DISPLAY_DOWN:
					if not obj.is_connected_to(found_rooms[0].get_dataclass_instance(),1):
						add_blueprint_connecting(d,i.position, obj, found_rooms[0].get_dataclass_instance())

func __prepare_blueprint(direction : RoomConnection.display_direction,_position:Vector2) -> BlueprintRoomConnection:
	var adjusted_position = Vector2(RoomConnection.get_display_direction_vector(direction))*room_distance/2+_position
	var blueprint :BlueprintRoomConnection = BLUEPRINT_ROOM_CONNECTION.instantiate()
	print("ADDING BLUEPRINT ",direction," ",position,adjusted_position)
	blueprint.position=adjusted_position
	blueprint.direction=direction
	blueprint.z_index=-5
	blueprint.pressed.connect(clicked_blueprint.bind(blueprint))
	return blueprint

func add_blueprint_directional(direction : RoomConnection.display_direction,_position:Vector2,room_origin:Room):
	var blueprint = __prepare_blueprint(direction,_position)
	blueprint.origin_room=room_origin
	blueprint.connecting_to=null
	display_nodes_folder.add_child(blueprint) 

func add_blueprint_connecting(direction : RoomConnection.display_direction,_position:Vector2,room_origin:Room,connecting:Room):
	var blueprint = __prepare_blueprint(direction,_position)
	blueprint.origin_room=room_origin
	blueprint.connecting_to=connecting
	blueprint.no_arrow=true
	display_nodes_folder.add_child(blueprint)

func clicked_blueprint(bp : BlueprintRoomConnection):
	current_room=null
	center_around_node(bp)
	selected_blueprint=bp
	button_scaler_bp()

func do_blueprint():
	blueprint_construction.emit(selected_blueprint)
	button_scaler.hide()

func cancel_blueprint():
	button_scaler.hide()

func button_scaler_none():
	button_scaler.hide()

func button_scaler_bp():
	accept.show()
	cancel.show()
	upgrade.hide()
	button_scaler.show()
	button_scaler.scale=Vector2(0.1,0.1)
	if not button_scaler.visible:
		var tween = get_tree().create_tween()
		tweens.append(tween)
		tween.tween_property(button_scaler,"scale",Vector2.ONE,.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	else:
		button_scaler.scale=Vector2.ONE

func button_scaler_upgrade():
	accept.hide()
	cancel.hide()
	upgrade.show()
	button_scaler.show()
	button_scaler.scale=Vector2(0.1,0.1)
	if not button_scaler.visible:
		var tween = get_tree().create_tween()
		tweens.append(tween)
		tween.tween_property(button_scaler,"scale",Vector2.ONE,.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	else:
		button_scaler.scale=Vector2.ONE

func upgrade_room():
	if current_room:
		try_upgrade_room.emit(current_room)
	button_scaler_none()

func center_around_node(node:Node2D,animated=true):
	print("boop")
	center_around(node.position,animated)
