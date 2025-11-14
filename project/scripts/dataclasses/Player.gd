extends Resource
class_name Player

@export var money : float : set=set_money
@export var inventory : Dictionary[StringName,int]

signal money_changed

func set_money(new_money):
	money=new_money
	money_changed.emit()
