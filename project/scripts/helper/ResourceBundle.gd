@tool
extends Resource
class_name ResourceBundle
## Class to create @export like references to resources at editing time, while being able to load them with a single UID through this bundle.
## This way you don't have to use load() or a ton of preload()'s

@export var resources : Array[Resource]

@export_dir var directory : String
@export var ScriptName : String
@export_tool_button("Preload from directory") var read_dir_button = read_dir_func

func read_dir_func():
	print(directory)
	var dir := DirAccess.open(directory)
	for file_name in dir.get_files():
		var path = directory + "/" + file_name
		var res = load(path)
		if not res.get_script() or res.get_script().get_global_name()!=ScriptName:
			continue
		resources.append(res)
