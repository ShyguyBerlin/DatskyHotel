extends Resource
class_name Habitant

@export var name = "Alice"

@export var residence : Room
@export var needs : Array[HabitantNeed]
@export var assets : Array[HabitantProperty]

func process(delta : float):
	for i in needs:
		i.process(delta)
