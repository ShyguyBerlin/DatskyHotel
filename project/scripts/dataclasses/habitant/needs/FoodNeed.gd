extends HabitantNeed

var foodLevel=4

func unbind_habitant() -> void:
	habitant.recieved_gift.disconnect(consume_gift_action)

func bind_habitant() -> void:
	habitant.recieved_gift.connect(consume_gift_action)
	GameTimeManager.MediumCycleTick.connect(_on_food_cycle_tick)

func consume_gift_action(action:GiftAction):
	var item = action.get_item()
	if item is FoodItem:
		foodLevel+=item.nutritional_value

func process(delta : float):
	pass

func _on_food_cycle_tick(ticks):
	# Expects a cycle to go about 20min
	reduce_food_level(ticks * 60 * 20)
	print("Food Cycle!")

func reduce_food_level(seconds : float):
	# Here we can influence how long 1 nutrient lasts
	# 1-100 nutrients per food, maybe more
	# 
	# For now, one nutrient is worth five minutes of saturation
	foodLevel-= seconds / 300

func generate_request(residence : Residence) -> Array[Request]:
	if foodLevel<=6:
		var req = FoodRequest.new(residence,habitant,self)
		return [req]
	return []
