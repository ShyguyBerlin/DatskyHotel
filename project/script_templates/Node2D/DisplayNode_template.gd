# meta-name: DisplayNode template
# meta-description: Template for creating display nodes that visualize dataclass instances
# meta-default: true
# meta-space-indent: 4

extends Node2D

# The dataclass instance this display node represents
@export var _DATACLASS_NAME_ : _DATACLASS_TYPE_

# Returns the dataclass instance associated with this display node
func get_dataclass_instance() -> _DATACLASS_TYPE_:
	return _DATACLASS_NAME_

# Sets the dataclass instance for this display node
func set_dataclass_instance(new_model : _DATACLASS_TYPE_):
	_DATACLASS_NAME_ = new_model
	# Call any update methods here
	update_display()

# Override this method to update the visual representation
func update_display():
	# Add your display update logic here
	pass

# Optional: Override _ready() to initialize display
func _ready():
	if _DATACLASS_NAME_:
		update_display()