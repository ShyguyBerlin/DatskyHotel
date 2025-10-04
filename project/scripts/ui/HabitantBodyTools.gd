@tool
extends Node2D


@export var clothing : Clothing
@export_tool_button("Copy offsets") var copy_offsets_func=copy_outfit_offsets
@export var assume_bodytype : HabitantOutfit.BodyType

## Lets put this to HabDisplay, so they can care for bodypart indexes
func draw_layer_to_node_layer(layer: int,bodypart: Clothing.BodyPart) -> int:
	var layers={Clothing.ClothingLayer.SKIN:0}
	match bodypart:
		Clothing.BodyPart.HEAD:
			layers[Clothing.ClothingLayer.HEADWEAR]=1
		Clothing.BodyPart.ARM_R,Clothing.BodyPart.ARM_L:
			layers[Clothing.ClothingLayer.TORSOCOVER]=1
		Clothing.BodyPart.TORSO:
			layers[Clothing.ClothingLayer.TORSOCOVER]=1
		Clothing.BodyPart.HIP:
			layers[Clothing.ClothingLayer.PANTS]=1
			layers[Clothing.ClothingLayer.TORSOCOVER]=2
		Clothing.BodyPart.LEG_R,Clothing.BodyPart.LEG_L:
			layers[Clothing.ClothingLayer.PANTS]=1
		Clothing.BodyPart.SHIN_R,Clothing.BodyPart.SHIN_L:
			layers[Clothing.ClothingLayer.PANTS]=1
		Clothing.BodyPart.FOOT_R,Clothing.BodyPart.FOOT_L:
			layers[Clothing.ClothingLayer.PANTS]=1
		_:
			pass
	if not layer in layers:
		printerr("Tried to convert clothing layer [",[layer],"] at Bodypart [",bodypart,"] to node index which does not exist")
		return -1
	return layers[layer]

func copy_outfit_offsets()->void:
	if not clothing:
		return
	var do_offset_position_warning=false
	for p in clothing.parts:
		print(p.bodypart)
		if p==null:
			continue
		var layer : int = draw_layer_to_node_layer(p.layer,p.bodypart)
		var node : Sprite2D = body_part_node(p.bodypart)
		if layer>0:
			if layer>node.get_child_count():
				printerr("Tried to fetch clothing at Bodypart [",p.bodypart,"], layer [",layer,"] which does not exist")
				continue
			node=node.get_child(layer-1)
		
		var override : ClothingPartOverride = null
		for o : ClothingPartOverride in p.overrides:
			if o.bodytype==assume_bodytype:
				override=o
				break
		if layer>0 and node.offset!=Vector2.ZERO and node.position!= Vector2.ZERO:
			do_offset_position_warning=true
		if override:
			override.offset=node.offset
			if layer>0:
				override.offset+=node.position
		else:
			p.offset=node.offset
			if layer>0:
				p.offset+=node.position
	if do_offset_position_warning:
		push_warning("Be aware that a clothing position also goes into offset for clothing on layer 1 and beyond. This is only used for editing, after a redraw, all clothing layers will have their position reset to 0.")
@onready var bodypart_forearm_l: Sprite2D = %ForearmL
@onready var bodypart_arm_l: Sprite2D = %ArmL
@onready var bodypart_hand_l: Sprite2D = %HandL
@onready var bodypart_shin_l: Sprite2D = %ShinL
@onready var bodypart_leg_l: Sprite2D = %LegL
@onready var bodypart_foot_l: Sprite2D = %FootL
@onready var bodypart_neck: Sprite2D = %Neck
@onready var bodypart_hip: Sprite2D = %Hip
@onready var bodypart_torso: Sprite2D = %Torso
@onready var bodypart_forearm_r: Sprite2D = %ForearmR
@onready var bodypart_arm_r: Sprite2D = %ArmR
@onready var bodypart_hand_r: Sprite2D = %HandR
@onready var bodypart_shin_r: Sprite2D = %ShinR
@onready var bodypart_leg_r: Sprite2D = %LegR
@onready var bodypart_foot_r: Sprite2D = %FootR
@onready var bodypart_head: Sprite2D = %Head

func body_part_node(bodypart: Clothing.BodyPart) -> Sprite2D:
	match bodypart:
		Clothing.BodyPart.HEAD:
			return bodypart_head
		Clothing.BodyPart.NECK:
			return bodypart_neck
		Clothing.BodyPart.TORSO:
			return bodypart_torso
		Clothing.BodyPart.HIP:
			return bodypart_hip
		Clothing.BodyPart.ARM_R:
			return bodypart_arm_r
		Clothing.BodyPart.FOREARM_R:
			return bodypart_forearm_r
		Clothing.BodyPart.HAND_R:
			return bodypart_hand_r
		Clothing.BodyPart.ARM_L:
			return bodypart_arm_l
		Clothing.BodyPart.FOREARM_L:
			return bodypart_forearm_l
		Clothing.BodyPart.HAND_L:
			return bodypart_hand_l
		Clothing.BodyPart.LEG_R:
			return bodypart_leg_r
		Clothing.BodyPart.SHIN_R:
			return bodypart_shin_r
		Clothing.BodyPart.FOOT_R:
			return bodypart_foot_r
		Clothing.BodyPart.LEG_L:
			return bodypart_leg_l
		Clothing.BodyPart.SHIN_L:
			return bodypart_shin_l
		Clothing.BodyPart.FOOT_L:
			return bodypart_foot_l
		_:
			return null
