extends Action
class_name GiftAction

var item_name
var display_node # To play a "thank you" dialog

func _init(item : String):
	self.item_name=item

func get_item():
	return ItemManager.get_item(item_name)
