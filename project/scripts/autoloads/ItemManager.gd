extends Node

var items:Dictionary[String,Item]

# Collection of items which are specifically Food, may be used for Food Quests idk
var food_items:Array[String]
var preloaded_items : ResourceBundle=preload("uid://ta8aj6kjow8o")# Assets/ItemCollection.tres : ResourceBundle

func _init():
	print("Initializing Items")
	for item in preloaded_items.resources:
		if not item is Item:
			printerr("ItemCollection is broken, ",item," is not an Item. It is of type ", item.get_script().get_global_name(), " instead.")
			continue
		item = item as Item
		add_item(item)

func add_item(item:Item):
	if item.system_name in items:
		printerr("ERROR ItemManager.add_item: Item ",item.system_name," already present!")
		return
	items[item.system_name]=item
	print("added Item ",item.name," [",item.system_name,"]")

func get_item(system_name:String) -> Item:
	if not system_name in items:
		printerr("ERROR ItemManager.get_item: Item ",system_name," not present!")
		return null
	return items.get(system_name)
