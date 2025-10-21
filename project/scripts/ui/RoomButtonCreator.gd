@tool
extends HBoxContainer

@export_tool_button("Convert Children") var convert_child_buttons_func=convert_child_buttons
@export_tool_button("!! Apply Button list (Destroys non-converted children) !!") var apply_button_list_func=apply_button_list

var buttonTemplate = preload("res://nodes/StandardHotelButton.tscn")
@export var buttons : Array[HotelButtonData] = []

@onready var input_handler = %HotelInputHandler

var __current_room :Room = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not Engine.is_editor_hint():
		apply_button_list_func.call()
	update_button_visibility.call_deferred()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func convert_child_buttons():
	buttons.clear()
	for i in get_children():
		if i is Button:
			i = i as Button
			var button_data : HotelButtonData = HotelButtonData.new()
			button_data.button_text = i.text
			button_data.button_icon = i.icon
			for s in i.get_signal_connection_list("pressed"):
				var call = s.get("callable") as Callable
				if not call.get_object() is HotelInputManager:
					printerr("RoomButtonCreator can only create and filter buttons which signal to the HotelInputManager. This is not valid:",s)
					continue
				button_data.button_actions.append(call.get_method())
			buttons.append(button_data)


func apply_button_list():
	for i in get_children():
		i.queue_free()
	for i in range(len(buttons)):
		var button_data:HotelButtonData=buttons[i]
		var new_button = buttonTemplate.instantiate()
		if not new_button is Button:
			printerr("ButtonTemplate is not a Button!!!")
			return
		new_button.name="GeneratedButton"+str(i)
		new_button = new_button as Button
		new_button.text=button_data.button_text
		new_button.icon=button_data.button_icon
		if input_handler:
			for act in button_data.button_actions:
				if not input_handler.has_method(act):
					printerr("InputHandler does not have the method: ",act)
					continue
				new_button.connect("pressed",Callable(input_handler,act))
		add_child(new_button)

func matches_type(value: Variant, T: Variant, exact: bool = false) -> bool:

	# Nothing can't be anything
	if value == null:
		return false

	# --- Built-in value types (Vector2, String, int, etc.)
	if typeof(value) != TYPE_OBJECT:
		if not exact:
			return is_instance_of(value, T)  # inheritance not really relevant for variants
		return typeof(value) == typeof(T)
	
	if not value is Object:
		return false
	
	value = value as Object
	
	if T is Script:
		return value.get_script() == T if exact else is_instance_of(value, T)
	
	if T is String or T is StringName:
		if not ClassDB.class_exists(T):
			if not value.get_script():
				return false
			if exact:
				return value.get_script().get_global_name() == T
			else:
				var script : Script = value.get_script()
				while script!=null:
					if script.get_global_name() == T:
						return true
					script=script.get_base_script()
				return false
		return value.get_class() == str(T) if exact else ClassDB.is_parent_class(value.get_class(), str(T))
	
	# Fallback: assume T is a class reference (like Button)
	return value.get_class() == T.get_class() if exact else is_instance_of(value, T)


func current_room_updated(new_current_room):
	__current_room=new_current_room
	update_button_visibility()

func update_button_visibility():
	if not is_node_ready():
		return

	if __current_room == null:
		for i in get_children():
			i.hide()
		return
		
	for i in range(len(buttons)):
		var button_data= buttons[i]
		var button=get_child(i)
		if not button_data.room_whitelist.is_empty():
			var allowed=false
			for rt in button_data.room_whitelist:
				if matches_type(__current_room,rt,true):
					allowed=true
					break
			if not allowed:
				button.hide()
				continue
		button.show()
		for rt in button_data.room_blacklist:
				if is_instance_of(__current_room,rt):
					button.hide()
					break
				
