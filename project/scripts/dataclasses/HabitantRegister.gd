extends Resource
class_name HabitantRegister

@export var habitants : Array[Habitant] = []

func get_homeless_habitants() -> Array[Habitant]:
	var homeless = []
	for i in habitants:
		if i.residence==null:
			homeless.append(i)
	return homeless

func register_habitant(hab: Habitant):
	habitants.append(hab)

func process_habitants(delta):
	for i in habitants:
		i.process(delta)
