@tool
extends OptionButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	clear()
	for i in HabitantDisplay.HabitantExpression:
		add_item(i,HabitantDisplay.HabitantExpression[i])
