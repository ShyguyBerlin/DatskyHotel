# GdUnit generated TestSuite
class_name UiMenuHolderTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source: String = 'res://scripts/ui/UIMenuHolder.gd'

# Test to check for a bug where having 2 menus open together and then closing one will break the closing mechanism
func test_child_visibility_changed() -> void:
	var root = auto_free(Control.new())
	var menuholder = spy(auto_free(load(__source).new()))
	
	var menu1 = auto_free(Control.new())
	var menu2 = auto_free(Control.new())
	menu1.visible=false
	menu2.visible=false
	root.add_child(menuholder)
	menuholder.add_child(menu1)
	menuholder.add_child(menu2)

	var runner = scene_runner(root)
	
	menu1.show()
	runner.simulate_frames(1)
	
	# This happens if a button is pressed in the background which opens another menu
	# Button press -> new menu -> gui input propagates to this and closes first menu
	menu2.show()
	menu1.hide()
	
	runner.simulate_frames(1)

	verify(menuholder,2).child_visibility_changed(menu1)
	verify(menuholder,1).child_visibility_changed(menu2)
	
	# This should close the first menu
	runner.simulate_mouse_button_press(MOUSE_BUTTON_LEFT)
	
	runner.simulate_frames(1)
	
	verify(menuholder,2).child_visibility_changed(menu1)
	verify(menuholder,2).child_visibility_changed(menu2)
	for i in menuholder.get_children():
		assert_bool(i.visible).is_false()
	assert_int(menuholder.mouse_filter).is_equal(Control.MOUSE_FILTER_STOP)
