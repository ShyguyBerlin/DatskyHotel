extends Control

@export var shop_items : Array[ShopItem]

@onready var item_container: VBoxContainer = %ItemContainer

@onready var item_line_node_prefab: PanelContainer = %ItemLine

@onready var item_name_label: RichTextLabel = %ItemNameLabel
@onready var count_label: RichTextLabel = %CountLabel
@onready var nutrient_label: RichTextLabel = %NutrientLabel
@onready var price_label: RichTextLabel = %PriceLabel
@onready var price_per_nutrient_label: RichTextLabel = %PricePerNutrientLabel
@onready var icon: TextureRect = %Icon


signal item_selected(idx:int)

signal item_selection_confirmed(idx:int)

# THIS IS TERRIBLE, PLEASE FIND ALTERNATIVE
var inventory_holder : Variant

var item_list : Array[Node] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	item_line_node_prefab.hide()

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
	var own_count=inventory_holder.inventory.get()
	count_label.text="x"+str(own_count)
	price_label.text=str(snappedf(shop_item.price,0.01))
	if item is FoodItem:
		nutrient_label.text=str(item.nutritional_value)+" nutrients"
	else:
		nutrient_label.text=""
	
	icon.texture=item.icon
	
	var item_line=item_line_node_prefab.duplicate()
	item_line.show()
	item_line.pressed.connect(selected_item.bind(item_list.size()))
	item_list.append(item_line)
	
	item_container.add_child(item_line)
	print("added itemline to item container ",item_line, " ", item_line.get_parent())
