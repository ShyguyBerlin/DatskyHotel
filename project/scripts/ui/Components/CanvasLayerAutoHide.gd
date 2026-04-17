extends CanvasLayer
class_name CanvasLayerAutoHide

## Needs to be set at startup
@export var copy_visibility_of : CanvasItem

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not copy_visibility_of:
		return
	copy_visibility_of.visibility_changed.connect(apply_visibility)

func apply_visibility():
	visible=copy_visibility_of.visible
