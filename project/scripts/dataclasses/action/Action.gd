## This is effectively a consumable Event
## Intended use is to send via emitted signal and subscribers can consume the event
## So if not consumed a default action triggers
## This allows for extensible behavior without changing the original reciever of the event
class_name Action

var consumed = false

func consume() -> void:
	consumed=true

func is_consumed() -> bool:
	return consumed
