extends Button

@export var build_mode_enabled : bool
@export var show_if_build_mode_disabled : Array[Node]
@export var show_if_build_mode_enabled : Array[Node]

# this is extremely lazy and extremely temporary
@export var sync_properties : PackedStringArray

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pressed.connect(toggle_build_mode)
	apply_build_mode_visibility()

func toggle_build_mode():
	build_mode_enabled = not build_mode_enabled
	print("Build mode is now ","enabled" if build_mode_enabled else "disabled")
	apply_build_mode_visibility()

func apply_build_mode_visibility():
	
	var shown_nodes : Array[Node] = show_if_build_mode_disabled if not build_mode_enabled else show_if_build_mode_enabled
	var hidden_nodes : Array[Node] = show_if_build_mode_disabled if build_mode_enabled else show_if_build_mode_enabled
	
	for i in show_if_build_mode_disabled:
		if build_mode_enabled:
			i.hide()
		else:
			i.show()
	
	for i in show_if_build_mode_enabled:
		if build_mode_enabled:
			i.show()
		else:
			i.hide()
	
	for i in range(len(hidden_nodes)):
		for p in sync_properties:
			shown_nodes[i].set(p,hidden_nodes[i].get(p))
