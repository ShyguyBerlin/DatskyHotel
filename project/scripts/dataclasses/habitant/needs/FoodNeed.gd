extends HabitantNeed

var foodLevel=30

func process(delta : float):
	foodLevel-=delta
	foodLevel=max(foodLevel,0)

func generate_request(residence : Residence) -> Array[Request]:
	if foodLevel<=10:
		var req = FoodRequest.new(residence,habitant,self)
		return [req]
	return []
