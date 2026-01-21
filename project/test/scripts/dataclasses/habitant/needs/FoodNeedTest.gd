# GdUnit generated TestSuite
class_name FoodNeedTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source: String = 'res://scripts/dataclasses/habitant/needs/FoodNeed.gd'


func test_consume_gift_action() -> void:
	# Setup minimal hotel like HotelLoader does
	var hotel = Hotel.new()
	var residence = Residence.new()
	hotel.initial_room = residence
	
	var habitant = spy(Habitant.new())
	habitant.name = "Test Habitant"
	var food_need = spy(preload("uid://dqew5h564cmig").new())
	habitant.add_need(food_need)
	residence.resident = habitant
	habitant.residence = residence
	
	# Set initial food level
	var initial_food_level = 5.0
	food_need.foodLevel = initial_food_level
	
	# Ensure no pending requests
	hotel.requests.clear()
	
	# Create Player with food item in inventory
	var player = Player.new()
	player.inventory = {"pirozhki": 1} as Dictionary[StringName, int]
	
	# CRITICAL: Prevent HotelInputHandler._ready() from overwriting player_instance
	# SaveSystem is an autoload that may have loaded a savegame with first_start=false
	# Setting first_start=true ensures _ready() won't replace our test player
	SaveSystem.save.first_start = true
	
	# Set up HotelManager with our test hotel
	HotelManager.hotel_instance = hotel
	
	# Set up the scene with HotelDisplay and HotelInputHandler
	var hotel_display = auto_free(load("uid://vbxq2syg5rg2").instantiate())
	hotel_display.current_room = residence
	
	var input_handler = auto_free(HotelInputManager.new())
	input_handler.player_instance = player
	input_handler.hotel_display_node = hotel_display
	
	# Add to scene tree and run
	var root = auto_free(Node.new())
	root.add_child(hotel_display)
	root.add_child(input_handler)
	var runner = scene_runner(root)
	
	runner.simulate_frames(3)
	
	# Wait for scene to be ready and for draw_hotel to be called
	await await_idle_frame()
	
	# Ensure hotel display has drawn the rooms and populated room_mapping
	# This is critical because finished_gift_menu needs get_current_display_node() to work
	if not residence in hotel_display.room_mapping:
		hotel_display.draw_hotel()
		await await_idle_frame()
	
	# Make sure foodNeed was correctly initizalized
	verify(food_need,1).bind_habitant()
	
	# Call finished_gift_menu with food item
	assert_signal(habitant).is_emitted("recieved_gift")
	input_handler.finished_gift_menu("pirozhki")
	verify(habitant,1).recieve_gift(any())
	verify(food_need,1).consume_gift_action(any())
	
	
	
	# Wait for processing
	await await_idle_frame()
	
	# Verify food level increased
	var pirozhki_item = ItemManager.get_item("pirozhki") as FoodItem
	var expected_food_level = initial_food_level + pirozhki_item.nutritional_value
	assert_float(food_need.foodLevel).is_equal_approx(expected_food_level, 0.001)
	
	
	# Verify item was consumed from inventory
	assert_bool(player.inventory.has("pirozhki")).is_false()
	hotel_display.queue_free()
	await await_idle_frame()

func test_gift_fulfills_food_request() -> void:
	# Setup minimal hotel like HotelLoader does
	var hotel = Hotel.new()
	var residence = Residence.new()
	hotel.initial_room = residence
	
	var habitant = spy(Habitant.new())
	habitant.name = "Test Habitant"
	var food_need = spy(preload("uid://dqew5h564cmig").new())
	habitant.add_need(food_need)
	residence.resident = habitant
	habitant.residence = residence
	
	# Set initial food level LOW to trigger request generation
	var initial_food_level = 3.0
	food_need.foodLevel = initial_food_level
	
	# Generate food request from the habitant
	var requests = food_need.generate_request(residence)
	assert_int(requests.size()).is_equal(1)
	var food_request = requests[0] as FoodRequest
	assert_object(food_request).is_not_null()
	
	# Add request to hotel and accept it (sets up signal connections)
	hotel.requests.append(food_request)
	food_request.accept()
	food_request.fulfilled.connect(hotel.remove_request)
	
	# Create Player with food item in inventory
	var player = Player.new()
	player.inventory = {"pirozhki": 2} as Dictionary[StringName, int]
	
	# CRITICAL: Prevent HotelInputHandler._ready() from overwriting player_instance
	SaveSystem.save.first_start = true
	
	# Set up HotelManager with our test hotel
	HotelManager.hotel_instance = hotel
	
	# Set up the scene with HotelDisplay and HotelInputHandler
	var hotel_display = auto_free(load("uid://vbxq2syg5rg2").instantiate())
	hotel_display.current_room = residence
	
	var input_handler = auto_free(HotelInputManager.new())
	input_handler.player_instance = player
	input_handler.hotel_display_node = hotel_display
	
	# Add to scene tree and run
	var root = auto_free(Node.new())
	root.add_child(hotel_display)
	root.add_child(input_handler)
	var runner = scene_runner(root)
	
	runner.simulate_frames(3)
	
	# Wait for scene to be ready
	await await_idle_frame()
	
	# Ensure hotel display has drawn the rooms
	if not residence in hotel_display.room_mapping:
		hotel_display.draw_hotel()
		await await_idle_frame()
	
	# Verify request exists before gifting
	assert_int(hotel.requests.size()).is_equal(1)
	assert_object(hotel.requests[0]).is_same(food_request)
	
	# Call finished_gift_menu with food item
	assert_signal(food_request).is_emitted("fulfilled")
	input_handler.finished_gift_menu("pirozhki")
	
	# Wait for processing - FoodRequest.consume_gift_action() is async and awaits dialog
	# Need to click through the dialog to allow it to complete
	await await_idle_frame()
	
	# Spam left clicks to skip through the dialog
	for i in range(20):
		runner.set_mouse_position(Vector2(200, 10))
		runner.simulate_mouse_button_pressed(MOUSE_BUTTON_LEFT)
		await await_idle_frame()
	
	# Wait for the fulfilled signal
	await await_idle_frame()
	
	# Verify the request was fulfilled and removed from hotel
	assert_int(hotel.requests.size()).is_equal(0)
	
	# Verify food level increased
	var pirozhki_item = ItemManager.get_item("pirozhki") as FoodItem
	var expected_food_level = initial_food_level + pirozhki_item.nutritional_value
	assert_float(food_need.foodLevel).is_equal_approx(expected_food_level, 0.001)
	
	# Verify item was consumed from inventory
	assert_int(player.inventory.get("pirozhki", 0)).is_equal(1)
	
	hotel_display.queue_free()
	await await_idle_frame()
