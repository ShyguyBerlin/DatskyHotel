@tool
extends TextureRect
class_name ShaderArcMaskedSprite

## Percentage filled (0.0 to 1.0)
@export_range(0.0, 1.0) var fill_percentage: float = 1.0:
	set(value):
		fill_percentage = clamp(value, 0.0, 1.0)
		if material and material is ShaderMaterial:
			material.set_shader_parameter("fill_percentage", fill_percentage)

## Starting angle in degrees (0 = right, -90 = up)
@export var start_angle_degrees: float = -90.0:
	set(value):
		start_angle_degrees = value
		if material and material is ShaderMaterial:
			material.set_shader_parameter("start_angle", deg_to_rad(start_angle_degrees))

## Whether to fill clockwise
@export var clockwise: bool = true:
	set(value):
		clockwise = value
		if material and material is ShaderMaterial:
			material.set_shader_parameter("clockwise", clockwise)

func _ready():
	
	var shader_material = preload("uid://sjnwtn5s1ar7")
	
	material = shader_material
	
	# Set initial values
	self.fill_percentage = fill_percentage
	self.start_angle_degrees = start_angle_degrees
	self.clockwise = clockwise
