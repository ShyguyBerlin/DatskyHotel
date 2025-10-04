@tool
extends Resource
class_name ClothingPart

## Determines on which bodypart the Clothing is drawn
@export var bodypart : Clothing.BodyPart = Clothing.BodyPart.TORSO
## Determines on which 'layer' the clothing is drawn
@export var layer : Clothing.ClothingLayer = Clothing.ClothingLayer.SKIN
## The texture to be drawn
@export var texture : Texture2D
## Some textures need offsets to display correctly, as the player model is centered around arbitrary base parts
@export var offset : Vector2
## Give alternative textures for certain underlying body types
@export var overrides : Array[ClothingPartOverride]
## Give this part a special tint
@export var tint : Color = Color.WHITE
## How to blend the tint with the standard tint of the clothing
@export var tint_blend_mode : TintBlendMode = TintBlendMode.CLOTHING

## Determines how to blend the Clothing base tint and the part specific tint
enum TintBlendMode {
	## Only take the base tint
	CLOTHING, 
	## Multiply Colors
	MIX, 
	## Only take the part specific tint
	PART 
}

class DrawInfo:
	var part : Clothing.BodyPart = Clothing.BodyPart.TORSO
	var layer : Clothing.ClothingLayer = Clothing.ClothingLayer.SKIN
	var texture
	var offset
	var tint : Color

## Should be used by clothing to give a HabitantNode an array of DrawInfos as a way to reduce logic there to drawrelated stuff
func get_draw_info(bodytype:HabitantOutfit.BodyType,base_clothing : Clothing) -> DrawInfo:
	var DI = DrawInfo.new()
	var blend_mode=TintBlendMode.MIX
	
	# Part specific
	DI.part=bodypart
	DI.layer=layer
	
	# might be overidden
	DI.texture=texture
	DI.offset=offset
	DI.tint=tint
	blend_mode=tint_blend_mode
	for o in overrides:
		if o.bodytype==bodytype:
			if o.texture:
				DI.texture=o.texture
			DI.offset=o.offset
			DI.tint=o.tint
			blend_mode=o.tint_blend_mode
			break
	
	match blend_mode:
		TintBlendMode.CLOTHING:
			DI.tint=base_clothing.tint
		TintBlendMode.MIX:
			DI.tint=DI.tint*base_clothing.tint
		TintBlendMode.PART:
			pass
	return DI
