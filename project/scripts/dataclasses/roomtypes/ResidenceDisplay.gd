extends Node2D

@export var residence : Residence : set = set_dataclass_instance
@export var dialog_balloon: PackedScene

@onready var habitant_display: HabitantDisplay = %Habitant

@onready var whiteboard: TextureRect = %Whiteboard
@onready var quest_icon: TextureRect = %QuestIcon

func get_dataclass_instance() -> Residence:
	return residence

func set_dataclass_instance(new_model : Residence):
	if residence:
		residence.resident_changed.disconnect(_draw)
	residence=new_model
	residence.resident_changed.connect(_draw)
	queue_redraw()

func _ready() -> void:
	queue_redraw()

func _draw():
	if not is_node_ready():
		return
	if not residence:
		habitant_display.hide()
		return
	draw_inhabitant()
	draw_quest_icon()

func draw_inhabitant():
	if residence.resident:
		habitant_display.set_dataclass_instance(residence.resident)
		habitant_display.show()
	else:
		habitant_display.hide()

func draw_quest_icon():
	var reqAction=ValueRequestAction.new()
	reqAction.request="QUEST_ICON"
	residence.get_quest_icon(reqAction)
	if (not reqAction.is_consumed()) or reqAction.value==null:
		whiteboard.hide()
		return
	if not reqAction.value is Texture2D:
		printerr("ERROR: Requested Quest Icon, but got something else than Texture2D!!")
		return
	whiteboard.show()
	quest_icon.texture=reqAction.value

func start_habitant_dialog(dialogue_resource: DialogueResource, extra_info : Array=[]):
	#start(dialogue_resource: DialogueResource, title: String, extra_game_states: Array = []) -> void:
	if not residence or not residence.resident:
		return
	var extra_game_states=[]
	extra_game_states.append_array(extra_info)
	var std_info= {
		"residence":residence
	}
	std_info["habitant"]=residence.resident
	extra_game_states.append(std_info)
	if dialog_balloon:
		var balloon= dialog_balloon.instantiate()
		balloon.call_deferred("start",dialogue_resource,"start",extra_game_states)
		add_child(balloon)

func on_mouse_hovering() -> void:
	habitant_display.expression=HabitantDisplay.HabitantExpression.Wave

func on_mouse_stop_hovering() -> void:
	habitant_display.expression=HabitantDisplay.HabitantExpression.Idle
