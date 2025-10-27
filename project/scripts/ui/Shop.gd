extends Control

@export var catalog : Array[ShopItem]
@export var items_in_stock : int
@export var current_stock : Array[ShopItem]

@onready var balance_label: RichTextLabel = %BalanceLabel

@onready var item_container: GridContainer = %ItemContainer

@onready var item_line_node_prefab: PanelContainer = %ItemLine

@onready var item_name_label: RichTextLabel = %ItemNameLabel
@onready var count_label: RichTextLabel = %CountLabel
@onready var nutrient_label: RichTextLabel = %NutrientLabel
@onready var price_label: RichTextLabel = %PriceLabel
@onready var price_per_nutrient_label: RichTextLabel = %PricePerNutrientLabel
@onready var icon: TextureRect = %Icon

signal item_selected(idx:int)

signal item_selection_confirmed(idx:int)

# need to change this if I want to deal with smth else than the player
@export var inventory_holder : Player

var item_list : Array[Node] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	item_line_node_prefab.hide()
	restock()

func clear() -> void:
	item_list.clear()
	for c in item_container.get_children():
		if c!=item_line_node_prefab:
			c.queue_free()

func selected_item(idx):
	pass

func add_item(shop_item : ShopItem) -> void:
	var item=shop_item.get_item()
	if not item:
		return
	item_name_label.text=item.name
	var own_count=inventory_holder.inventory.get(item.name,0)
	count_label.text="x"+str(own_count)
	price_label.text=str(snappedf(shop_item.price,0.01))+"€"
	if item is FoodItem:
		nutrient_label.text=str(item.nutritional_value)+" nutrients"
		price_per_nutrient_label.text=str(snappedf(shop_item.price/(item.nutritional_value/10),0.01))+"€ per 10 nutrients"
	else:
		nutrient_label.text=""
		price_per_nutrient_label.text=""
	
	icon.texture=item.icon
	
	var item_line=item_line_node_prefab.duplicate()
	item_line.show()
	item_line.get_child(0).pressed.connect(selected_item.bind(item_list.size()))
	item_list.append(item_line)
	
	item_container.add_child(item_line)
	print("added itemline to item container ",item_line, " ", item_line.get_parent())

func open():
	clear()
	for i in current_stock:
		add_item(i)
	show()

func restock() -> void:
	current_stock.clear()
	
	var rem_catalog_items=range(0,len(catalog))
	for i in range(items_in_stock):
		var rnd_idx = rem_catalog_items.pick_random()
		current_stock.append(catalog[rnd_idx])
		rem_catalog_items.erase(rnd_idx)

func change_player_balance(new_balance):
	balance_label.text=str(new_balance)+"€"
