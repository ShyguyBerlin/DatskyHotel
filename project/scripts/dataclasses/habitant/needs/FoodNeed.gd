extends HabitantNeed

var foodLevel=30

func process(delta : float):
	foodLevel-=delta

func generate_request(residence : Residence) -> Array[Request]:
	if foodLevel<0:
		var req = FoodRequest.new(residence,habitant)
		return [req]
	return []
