extends Resource
class_name HotelButtonData

@export var button_text : String
@export var button_icon : Texture2D

# A list of callables to connect to a buttons 'pressed' signal
@export var button_actions : Array[String] = []

# No elements in whitelist should mean that all rooms are accepted
@export var room_whitelist : Array = []
@export var room_blacklist : Array = []
