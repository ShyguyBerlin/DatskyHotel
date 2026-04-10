extends Control
class_name RoomUpgradeMenu

signal room_type_selected(room_script:String)

var _clicked_item : int = -1

@onready var item_list = %ItemList

# Needed to know which options there are
var room_script_to_upgrade : Script

static var room_costs = {
	Room: 100,
	Residence: 120,
	Elevator: 280,
	MonitoringRoom: 600
}

static var upgrade_tree = {
	Room: [Residence, Elevator]
}

# Call this to open the window, provide with Player or inventory
func open(room : Room):
	var room_script = room.get_script()
	if room_script is Script:
		room_script_to_upgrade = room_script
		if room_script.get_global_name() == "":
			printerr("ERROR: bad open argument for Room Upgrade Menu, expected Resource with Script that has a class_name attribute. Please fix your Room type.")
			return
	else:
		printerr("ERROR: bad open argument for Room Upgrade Menu, expected Room Resource with Script attached")
		return
	populate_item_list()
	show()


func populate_item_list() -> void:
	item_list.clear()
	item_list.set_use_icons(false)
	_clicked_item=-1
	if room_script_to_upgrade in upgrade_tree:
		for i in upgrade_tree.get(room_script_to_upgrade):
			var room_script = i
			var room_script_title = room_script.get_global_name() as String
			if room_script_title == "":
				push_warning("WARNING: Room without class name in RoomUpgradeTree")
			item_list.add_item(room_script_title,room_script_title.to_upper(),null)
	else:
		print("bad room for upgrade")

func list_item_selected_final(index: int) -> void:
	_clicked_item=index
	finalize()

func list_item_selected(index: int) -> void:
	print("selected ",index)
	_clicked_item=index

func upgrade_button_pressed() -> void:
	if _clicked_item!=-1:
		finalize()

func finalize() -> void:
	print("final selected ",_clicked_item)
	hide()
	if _clicked_item==-1:
		room_type_selected.emit(null)
	else:
		room_type_selected.emit(upgrade_tree.get(room_script_to_upgrade)[_clicked_item])
