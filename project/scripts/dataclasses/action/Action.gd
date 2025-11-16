## This is effectively a consumable Event
## Intended use is to send via emitted signal and subscribers can consume the event
## So if not consumed a default action triggers
## This allows for extensible behavior without changing the original reciever of the event
class_name Action

## For now, I expect each action to be initiated by a Player: Talk or Gift are both actions and both are a response to player input
## Thus it makes sense to transmit info about the player via the action
## This can later be used for multiplayer and different players interacting with the same habitants
var player : Player = null
var consumed : bool = false
var display_node # To play a "thank you" dialog

func consume() -> void:
	consumed=true

func is_consumed() -> bool:
	return consumed


## Coroutine to play an animation and reward money to the player object
## Could also be done by Action-consumers, but should be standartised here
func reward_money(amount : float) -> void:
	player.money+=amount

const reward_dialog = preload("uid://418kkop5fyws")
## Same as reward_money but for items
func reward_item(item_name : String) -> void:
	var item = ItemManager.get_item(item_name)
	if not item:
		return
	player.inventory[item_name]=player.inventory.get(item_name,0)+1
	display_node.start_habitant_dialog(reward_dialog,[{"reward":item}])
