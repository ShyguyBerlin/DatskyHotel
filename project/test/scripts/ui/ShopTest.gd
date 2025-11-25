# GdUnit generated TestSuite
class_name ShopTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source: String = "res://nodes/ui/Shop.tscn"


func test_bought_item() -> void:
	var player = Player.new()
	
	var shop = auto_free(load(__source).instantiate())
	scene_runner(shop)
	await_idle_frame()
	var shop_item=ShopItem.new()
	shop_item.item_name=&"pirozhki"
	shop_item.price=1
	shop.current_stock=[shop_item] as Array[ShopItem]
	shop.inventory_holder=player
	
	player.money=1
	player.inventory={&"pirozhki":3} as Dictionary[StringName,int]
	
	shop.open()
	shop.bought_item(0)
	assert_float(player.money).is_equal_approx(0,0.0001)
	assert_int(player.inventory[&"pirozhki"]).is_equal(4)

func test_restock() -> void:
	var player = Player.new()
	
	var shop = auto_free(load(__source).instantiate())
	scene_runner(shop)
	await_idle_frame()
	
	var shop_item=ShopItem.new()
	shop_item.item_name=&"pirozhki"
	shop_item.price=1
	shop.inventory_holder=player
	
	shop.catalog=[shop_item,shop_item] as Array[ShopItem]
	shop.items_in_stock=2
	shop.restock()
	assert_int(len(shop.current_stock)).is_equal(2)

	shop.items_in_stock=1
	shop.restock()
	assert_int(len(shop.current_stock)).is_equal(1)

func test_open() -> void:
	var player = Player.new()
	
	var shop = auto_free(load(__source).instantiate())
	var shop_runner=scene_runner(shop)
	await_idle_frame()
	
	player.money=2
	
	var shop_item=ShopItem.new()
	shop_item.item_name=&"pirozhki"
	shop_item.price=1
	
	shop.inventory_holder=player
	shop.catalog=[shop_item] as Array[ShopItem]
	shop.items_in_stock=1
	shop.restock()
	await await_idle_frame()
	shop.open()
	shop_runner.set_mouse_position(Vector2(130,180))
	assert_signal(shop).is_emitted("item_bought",["pirozhki"])
	await await_idle_frame()
	shop_runner.simulate_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	shop_runner.await_input_processed()

	assert_float(player.money).is_equal_approx(1,0.0001)
	assert_int(player.inventory.get(&"pirozhki",0)).is_equal(1)
	shop_runner.simulate_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	shop_runner.await_input_processed()
	assert_float(player.money).is_equal_approx(0,0.0001)
	assert_int(player.inventory.get(&"pirozhki",0)).is_equal(2)
