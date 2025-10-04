extends Room
class_name Residence

@export var resident : Habitant : set =set_resident

signal resident_changed()

func set_resident(new_resident):
	resident=new_resident
	resident_changed.emit()

func get_display_node():
	return get_display_node_base("res://nodes/roomtypes/Residence/ResidenceDisplay.tscn")

func generate_request() -> Array[Request]:
	if not resident:
		return []
	return resident.generate_request(self)

func consume_talk_action(action : TalkAction):
	if resident:
		resident.consume_talk_action(action)
	return

func get_quest_icon(action : ValueRequestAction) -> void:
	requested_quest_icon.emit(action)
	if action.is_consumed():
		return
	if resident:
		resident.consume_quest_icon_request(action)
