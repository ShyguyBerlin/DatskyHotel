extends HabitantNeed

var foodLevel=30

func unbind_habitant() -> void:
	habitant.recieved_gift.disconnect(consume_gift_action)

func bind_habitant() -> void:
	habitant.recieved_gift.connect(consume_gift_action)

func consume_gift_action(action:GiftAction):
	var item = action.get_item()
	if item is FoodItem:
		foodLevel+=item.nutritional_value

func process(delta : float):
	foodLevel-=delta
	foodLevel=max(foodLevel,0)

func generate_request(residence : Residence) -> Array[Request]:
	if foodLevel<=10:
		var req = FoodRequest.new(residence,habitant,self)
		return [req]
	return []
