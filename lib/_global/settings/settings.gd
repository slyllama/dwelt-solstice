extends Node

const SETTINGS_PATH := "user://settings.json"

const default_data := { # default settings data
	"window_mode": "full_screen",
	"bloom": "off",
	"shadows": "low",
	"fps_limit": "60fps",
	"foliage_density": "medium",
	"foliage_render_distance": "high"
}

@onready var data := default_data.duplicate()

signal changed(setting: String)
signal file_loaded

func _settings_file_exists() -> bool:
	if FileAccess.file_exists(SETTINGS_PATH):
		return(true)
	else: return(false)

func change(setting: String, value: String) -> void:
	if setting in data:
		data[setting] = value
		changed.emit(setting)
		save_to_file()

func save_to_file() -> void:
	var _f = FileAccess.open(SETTINGS_PATH, FileAccess.WRITE)
	_f.store_line(JSON.stringify(data, "\t"))
	_f.close()
	print_rich("[color=#777][Settings] Saving...[/color]")

func load_file() -> void:
	if !_settings_file_exists(): # create new save
		Utils.pdebug("No file exists; creating one.", "Settings")
		var _f = FileAccess.open(SETTINGS_PATH, FileAccess.WRITE)
		_f.store_line(JSON.stringify(default_data, "\t"))
		_f.close()
	else: # load existing save
		Utils.pdebug("File exists; loading it.", "Settings")
		var _f = FileAccess.open(SETTINGS_PATH, FileAccess.READ)
		var _j = JSON.parse_string(_f.get_as_text())
		for _d in data:
			if _d in _j:
				data[_d] = _j[_d] # copy the value, but only if its key is in the save file
		_f.close()
	await get_tree().process_frame
	file_loaded.emit() # used for initial setup of setting pane fields
	for _s in data:
		changed.emit(_s) # propagate all settings on game start
