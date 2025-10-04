extends Resource
class_name ClothingPartOverride

## The Bodytype for which this override shall be applied
@export var bodytype : HabitantOutfit.BodyType
## The texture to be drawn
@export var texture : Texture2D
## Some textures need offsets to display correctly, as the player model is centered around arbitrary base parts
@export var offset : Vector2
## Give this part a special tint
@export var tint : Color = Color.WHITE
## How to blend the tint with the standard tint of the clothing
@export var tint_blend_mode : ClothingPart.TintBlendMode
