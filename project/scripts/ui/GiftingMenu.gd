extends Control

signal item_selected(item_name:String)

var _clicked_item : int = -1

@onready var item_list = %ItemList

var player : Player
var listed_inventory : Dictionary[StringName,int]

# Call this to open the window, provide with Player or inventory
func open(player):
	if player is Player:
		listed_inventory=player.inventory
	elif player is Dictionary:
		listed_inventory=player
	else:
		printerr("ERROR: bad open argument for InventorySelection Menu, expected player or inventory")
		return
	populate_item_list()
	show()

func populate_item_list() -> void:
	item_list.clear()
	item_list.set_use_icons(true)
	_clicked_item=-1
	for i in listed_inventory:
		var listed_item = ItemManager.get_item(i)
		if listed_item == null:
			printerr("ERROR: Nonexistent item in inventory")
			continue
		item_list.add_item(listed_item.name,"x"+str(listed_inventory[i]),listed_item.icon)

func list_item_selected_final(index: int) -> void:
	_clicked_item=index
	finalize()

func list_item_selected(index: int) -> void:
	print("selected ",index)
	_clicked_item=index

func gift_button_pressed() -> void:
	if _clicked_item!=-1:
		finalize()

func finalize() -> void:
	print("final selected ",_clicked_item)
	if _clicked_item==-1:
		item_selected.emit(null)
	else:
		item_selected.emit(listed_inventory.keys()[_clicked_item])
	hide()
