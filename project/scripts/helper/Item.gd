extends Resource
class_name Item

# Make sure this is unique, mostly relevant for mods (still not sure how mods will be implemented)
@export var system_name : String
# This does not have to be unqiue
@export var name : String

# Ideally this is a 64x64 pixel or higher res picture.
@export var icon : Texture2D
