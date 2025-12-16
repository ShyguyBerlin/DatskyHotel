extends Node

const DEBUG = false  # Set to true to enable debug output

const savegametype : Script = preload("uid://c84icr3cqf5v7")
const usersettingstype : Script = preload("uid://be6v6c6tj63yp")

signal loaded_new_save
signal loaded_old_save
signal reloaded_settings

@export var user_settings : usersettingstype = usersettingstype.new()
@export var save : savegametype = savegametype.new()

# Temporary reference used during savegame loading to provide early access to save extensions
var _loading_save : savegametype = null

# Get a save extension by name, works correctly both during and after loading
func get_save_extension(extension_name: String) -> Resource:
	# During loading, use the loading save; otherwise use current save
	var current_save = _loading_save if _loading_save else save
	if not current_save:
		return null
	if extension_name in current_save.save_extension:
		return current_save.save_extension[extension_name]
	return null

func _ready() -> void:
	get_tree().auto_accept_quit=false
	load_settings()
	load_savegame()

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST or what==NOTIFICATION_WM_GO_BACK_REQUEST or what==NOTIFICATION_APPLICATION_PAUSED:
		call_deferred("save_savegame")
		get_tree().call_deferred("quit")

func save_settings():
	var config = ConfigFile.new()
	
	config.set_value("general","save_game_path",user_settings.save_game_path)
	
	config.save("user://settings.cfg")

func load_settings():
	var config = ConfigFile.new()
	var err = config.load("user://settings.cfg")
	if err != OK:
		print("error during loading settings: ", err)
		return
	
	user_settings.save_game_path = config.get_value("general","save_game_path")
	reloaded_settings.emit()

func save_savegame():
	save.convert_to_ids()
	ResourceSaver.save(save,user_settings.save_game_path)
	save.convert_to_refs()

func load_savegame():
	if FileAccess.file_exists(user_settings.save_game_path):
		var new_save = ResourceLoader.load(user_settings.save_game_path)
		if new_save:
			if DEBUG:
				print("=== SAVEGAME LOADED ===")
				print("  save_extension keys: ", new_save.save_extension.keys())
				if "datsky_relationships" in new_save.save_extension:
					var rel_data = new_save.save_extension["datsky_relationships"]
					print("  relationship data found (",rel_data,"), _accounts keys: ", rel_data._accounts.keys())
			
			# Set _loading_save FIRST so get_save_extension() works during loading
			_loading_save = new_save
			new_save.convert_to_refs()
			save = new_save
			new_save.reconnect_signals()
			new_save.first_start = false
			
			# Clear _loading_save after all loading operations complete
			_loading_save = null
			
			if DEBUG:
				print("=== SAVEGAME FULLY LOADED AND READY ===")
			loaded_old_save.emit()
			return
	loaded_new_save.emit()
