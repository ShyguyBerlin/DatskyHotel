extends Node

const savegametype : Script = preload("uid://c84icr3cqf5v7")
const usersettingstype : Script = preload("uid://be6v6c6tj63yp")

signal loaded_new_save
signal reloaded_settings

@export var user_settings : usersettingstype = usersettingstype.new()
@export var save : savegametype = savegametype.new()

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
			new_save.convert_to_refs()
			save=new_save
			reloaded_settings.emit()
			save.first_start=false
