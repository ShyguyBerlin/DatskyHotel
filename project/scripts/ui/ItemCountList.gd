extends Panel


@onready var item_container: VBoxContainer = %ItemContainer

@onready var item_line_node_prefab: Button = %ItemLine

@onready var item_icon: Control = %ItemIcon
@onready var label_left: RichTextLabel = %LabelLeft
@onready var label_right: RichTextLabel = %LabelRight

signal item_selected(idx:int)

signal item_selection_confirmed(idx:int)

var selected_idx=-1

var item_list : Array[Node] = []
var use_icons : bool =false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	item_line_node_prefab.hide()

func clear() -> void:
	item_list.clear()
	selected_idx=-1
	for c in item_container.get_children():
		if c!=item_line_node_prefab:
			c.queue_free()

func set_use_icons(val):
	use_icons=val
	if not item_list.is_empty():
		printerr("Tried to change use of icons with non-empty item list, this can cause glitchy item lines, try to avoid")
	if not use_icons:
		item_icon.hide()
	else:
		item_icon.show()

func selected_item(idx):
	if selected_idx==idx:
		item_selection_confirmed.emit(idx)
	else:
		# Switch to normal panel
		item_list[selected_idx].get_child(1).hide()
		selected_idx=idx
		# Switch to selected panel
		item_list[selected_idx].get_child(1).show()
		item_selected.emit(idx)

func add_item(text,textr="",icon:Texture2D=null) -> void:
	if use_icons:
		item_icon.show()
		var tex_rect = item_icon.get_child(0) as TextureRect
		tex_rect.texture=icon
	else:
		item_icon.hide()
	label_left.text=text
	label_right.text=textr
	var item_line=item_line_node_prefab.duplicate()
	item_line.show()
	item_line.pressed.connect(selected_item.bind(item_list.size()))
	item_list.append(item_line)
	
	item_container.add_child(item_line)
	print("added itemline to item container ",item_line, " ", item_line.get_parent())
