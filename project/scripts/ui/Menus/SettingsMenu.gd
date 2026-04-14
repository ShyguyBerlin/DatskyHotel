extends Control

var local_settings = UserSettings.new()
@onready var use_alt_button_control_toggle: ToggleButton = %UseAltButtonControlToggle

func save_and_close():
	SaveSystem.user_settings=local_settings
	SaveSystem.save_settings()
	close()

func open():
	local_settings=SaveSystem.user_settings.duplicate(true)
	
	use_alt_button_control_toggle.is_toggled=local_settings.use_alternative_button_controls
	
	show()

func close():
	hide()

func enable_alt_buttons_toggled(toggled_on: bool) -> void:
	local_settings.use_alternative_button_controls=toggled_on

func show_save_files():
	var save_path = ProjectSettings.globalize_path(local_settings.save_game_path)
	OS.shell_show_in_file_manager(save_path)
