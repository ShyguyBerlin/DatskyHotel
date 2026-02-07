extends Control

# This needs to match Tab arrangement
const TAB_RELATIONSHIP = 0

const RELATIONSHIP_CELL_SCENE = preload("res://nodes/ui/RelationshipCell.tscn")
const CELL_MIN_WIDTH = 200
const CELL_MARGIN = 10

@onready var tab_container: TabContainer = %TabContainer
@onready var relationship_grid: GridContainer = %RelationshipGrid

const relationship_save_extension_name="datsky_relationships"
var relationship_save_data: RelationshipSaveData

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Get relationship data from SaveSystem
	if "relationship" in SaveSystem.save.save_extension:
		relationship_save_data = SaveSystem.save.save_extension["relationship"]

func open():
	show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_visibility_changed() -> void:
	if visible:
		draw_tab_menu(tab_container.current_tab)

func _on_tab_container_tab_changed(tab: int) -> void:
	draw_tab_menu(tab)

func draw_tab_menu(tab_index : int) -> void:
	match tab_index:
		TAB_RELATIONSHIP:
			draw_relationship_tab()

func draw_relationship_tab():
	if not relationship_grid:
		push_error("RelationshipGrid not found in MonitoringMenu")
		return
	
	# Clear existing cells
	for child in relationship_grid.get_children():
		child.queue_free()
	
	# Get relationship data
	if not relationship_save_data:
		if relationship_save_extension_name in SaveSystem.save.save_extension:
			relationship_save_data = SaveSystem.save.save_extension[relationship_save_extension_name]
		else:
			push_warning("No relationship data found in SaveSystem")
			var no_data_label = Label.new()
			no_data_label.text = "No relationships found"
			relationship_grid.add_child(no_data_label)
			print("no relationships (data missing)")
			return
	
	var affiliations = relationship_save_data._affiliation_list
	var accounts = relationship_save_data.get_accounts()
	
	if affiliations.is_empty():
		var no_data_label = Label.new()
		no_data_label.text = "No relationships found"
		relationship_grid.add_child(no_data_label)
		print("no relationships")
		return
	
	# Calculate grid columns based on available width
	update_grid_columns()
	
	# Create cells for each affiliation
	for affiliation in affiliations:
		var cell = RELATIONSHIP_CELL_SCENE.instantiate()
		relationship_grid.add_child(cell)
		cell.setup(affiliation, accounts)
		print("added relationship cell for ",affiliation.id_A," and ",affiliation.id_B)

func update_grid_columns():
	if not relationship_grid:
		return
	
	# Get available width
	var available_width = size.x if size.x > 0 else get_viewport_rect().size.x
	
	# Calculate number of columns that fit
	var num_columns = max(1, int(available_width / (CELL_MIN_WIDTH + CELL_MARGIN)))
	
	relationship_grid.columns = num_columns
