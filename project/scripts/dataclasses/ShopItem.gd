extends Resource
class_name ShopItem

@export var item_name : String
@export var price : float

func get_item() -> Item:
	return ItemManager.get_item(item_name)
