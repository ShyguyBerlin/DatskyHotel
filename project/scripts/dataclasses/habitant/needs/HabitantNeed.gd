extends Resource
class_name HabitantNeed

var habitant : Habitant : set = set_habitant

# Probably not necessary
func unbind_habitant() -> void:
	pass

# Bind to signals
func bind_habitant() -> void:
	pass

func set_habitant(new_habitant):
	if habitant:
		unbind_habitant()
	habitant=new_habitant
	if habitant:
		bind_habitant()

func process(delta : float):
	pass

func generate_request(residence : Residence) -> Array[Request]:
	return []
