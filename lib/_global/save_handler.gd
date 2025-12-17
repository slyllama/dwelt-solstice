extends Node

const SAVE_PATH := "user://save.json"

const default_data := { # default save data
	"currency": {
		"arcane": "0",
		"elemental": "0",
		"kinetic": "0",
		"verdant": "0"
	},
	"inventory": {
		"1": { "id": "test_red" }
	}
}

@onready var data := default_data.duplicate()

signal loaded

func _save_file_exists() -> bool:
	if FileAccess.file_exists(SAVE_PATH):
		return(true)
	else: return(false)

func save_to_file() -> void:
	var _f = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	_f.store_line(JSON.stringify(data, "\t"))
	_f.close()
	loaded.emit()
	
	print_rich("[color=#777][Save] Saving...[/color]")

func load_save_file() -> void:
	if !_save_file_exists(): # create new save
		Utils.pdebug("No save file exists; creating one.", "Save")
		var _f = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
		_f.store_line(JSON.stringify(default_data, "\t"))
		_f.close()
		loaded.emit()
	else: # load existing save
		Utils.pdebug("Save file exists; loading it.", "Save")
		var _f = FileAccess.open(SAVE_PATH, FileAccess.READ)
		var _j = JSON.parse_string(_f.get_as_text())
		for _d in data:
			if _d in _j:
				data[_d] = _j[_d] # copy the value, but only if its key is in the save file
		_f.close()
		loaded.emit()
