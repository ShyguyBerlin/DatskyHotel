# GdUnit generated TestSuite
class_name HabitantTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source: String = 'res://scripts/dataclasses/habitant/Habitant.gd'

const __residence_display: Script = preload("uid://dnvmalkupb7uo")

func test_recieve_gift() -> void:
	var habitant = Habitant.new()
	var residence = Residence.new()
	residence.resident=habitant
	habitant.residence=residence
	var player = Player.new()
	var gift = GiftAction.new("bretzel")
	var displayNode = spy(auto_free(__residence_display.new()))
	gift.player=player
	gift.display_node=displayNode
	
	habitant.recieve_gift(gift)
	verify(displayNode,1).start_habitant_dialog(habitant.std_gift_dialog,any())

func test_recieve_gift_with_hunger() -> void:
	var habitant = Habitant.new()
	var residence = Residence.new()
	
	var hunger=preload("uid://dqew5h564cmig").new() # FoodNeed
	habitant.add_need(hunger)
	
	residence.resident=habitant
	habitant.residence=residence
	var player = Player.new()
	var gift = GiftAction.new("bretzel")
	var displayNode = spy(auto_free(__residence_display.new()))
	gift.player=player
	gift.display_node=displayNode
	hunger.foodLevel=0
	habitant.recieve_gift(gift)
	assert_float(hunger.foodLevel).is_greater(0.5)
	verify(displayNode,1).start_habitant_dialog(habitant.std_gift_dialog,any())
