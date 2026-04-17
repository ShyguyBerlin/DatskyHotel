extends Node3D

@export var room : Room

@onready var habitant_mesh: MeshInstance3D = %HabitantMesh
@onready var habitant: HabitantDisplay = %Habitant

@export var testMat : StandardMaterial3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func clear_room() -> void:
	habitant_mesh.hide()

func rebuild() -> void:
	clear_room()
	if not room:
		printerr("Room Interior View does not have a room. This should not happen")
	print("doing room ",room)
	match room.get_script():
		Residence:
			print("doing residence",room)
			room = room as Residence
			testMat.albedo_color=Color.PEACH_PUFF
			if room.resident:
				habitant.set_dataclass_instance(room.resident)
				habitant_mesh.show()
		MonitoringRoom:
			print("doing monitoring-room",room)
			room = room as MonitoringRoom
			testMat.albedo_color=Color.WEB_GRAY
		_:
			pass
