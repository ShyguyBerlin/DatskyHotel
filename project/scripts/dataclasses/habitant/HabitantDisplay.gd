@tool
extends Node2D
class_name HabitantDisplay

# The dataclass instance this display node represents
@export var habitant : Habitant : set=set_dataclass_instance
@export_tool_button("Redraw!") var redraw_func = update_display
@export var expression : HabitantExpression : set = set_expression

@onready var body: Node2D = %Body
@onready var anim_tree: AnimationTree = %AnimationTree

enum HabitantExpression {
	Idle,
	Wave,
	Pain
}
# Returns the dataclass instance associated with this display node
func get_dataclass_instance() -> Habitant:
	return habitant

# Sets the dataclass instance for this display node
func set_dataclass_instance(new_model : Habitant):
	habitant = new_model
	# Call any update methods here
	update_display()

func set_expression(new_expression):
	expression=new_expression
	show_habitant_expression()

# Override this method to update the visual representation
func update_display():
	if not is_node_ready():
		return
	# Add your display update logic here
	if habitant:
		apply_clothing_on_body(HabitantOutfit.get_skin_for_bodytype(habitant.bodytype))
		for i in body.get_children():
			i.self_modulate=habitant.body_color
		if habitant.outfit:
			apply_outfit_on_body(habitant.outfit)
		show_habitant_expression()
		body.show()
	else:
		body.hide()

## rawr
func undress():
	var parts :Array[Clothing.BodyPart] = [Clothing.BodyPart.HEAD,Clothing.BodyPart.NECK,Clothing.BodyPart.TORSO,Clothing.BodyPart.HIP,Clothing.BodyPart.ARM_R,Clothing.BodyPart.FOREARM_R,Clothing.BodyPart.HAND_R,Clothing.BodyPart.ARM_L,Clothing.BodyPart.FOREARM_L,Clothing.BodyPart.HAND_L,Clothing.BodyPart.LEG_R,Clothing.BodyPart.SHIN_R,Clothing.BodyPart.FOOT_R,Clothing.BodyPart.LEG_L,Clothing.BodyPart.SHIN_L,Clothing.BodyPart.FOOT_L]
	for p in parts:
		for c in body_part_node(p).get_children():
			if c.position!=Vector2.ZERO:
				c.position=Vector2.ZERO
				print("Reset position of clothinglayer ",c.name," to zero! Be sure to only change this while initially adjusting clothing offsets")
			if c.rotation!=0:
				c.rotation=0
				print("Reset rotation of clothinglayer ",c.name," to zero!")
			if c.scale!=Vector2.ONE:
				c.scale=Vector2.ONE
				print("Reset scale of clothinglayer ",c.name," to (1,1)!")

			c.hide()

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

func apply_clothing_drawinfo(drawinfo:ClothingPart.DrawInfo):
	var layer=draw_layer_to_node_layer(drawinfo.layer,drawinfo.part)
	var node : Sprite2D = body_part_node(drawinfo.part)
	if layer>0:
		if layer>node.get_child_count():
			printerr("Tried to draw clothing at Bodypart [",drawinfo.part,"], layer [",layer,"] which does not exist. This is a problem with HabitantDisplay.gd::draw_layer_to_node_layer")
			return
		node=node.get_child(layer-1)
	node.self_modulate=drawinfo.tint
	node.texture=drawinfo.texture
	node.offset=drawinfo.offset
	node.show()

func apply_clothing_on_body(clothing:Clothing):
	if not habitant or not clothing:
		return
	var drawinfos=clothing.get_draw_infos(habitant.bodytype)
	for i in drawinfos:
		apply_clothing_drawinfo(i)

func show_habitant_expression():
	if not is_node_ready():
		return
	var anim_strings={HabitantExpression.Idle:"idle",HabitantExpression.Wave:"wave",HabitantExpression.Pain:"pain"}
	anim_tree.set("parameters/Transition/transition_request",anim_strings.get(expression))

func apply_outfit_on_body(outfit:HabitantOutfit):
	undress() # also rawr
	apply_clothing_on_body(outfit.headwear)
	apply_clothing_on_body(outfit.facial_accessories)
	apply_clothing_on_body(outfit.torso_behind)
	apply_clothing_on_body(outfit.torso_front)
	apply_clothing_on_body(outfit.pants)
	apply_clothing_on_body(outfit.shoes)
	apply_clothing_on_body(outfit.hand_accessories)

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

# Optional: Override _ready() to initialize display
func _ready():
	if habitant:
		update_display()
