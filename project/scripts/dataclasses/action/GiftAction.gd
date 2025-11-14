extends Action
class_name GiftAction

var item_name

func _init(item : String):
	self.item_name=item

func get_item():
	return ItemManager.get_item(item_name)
