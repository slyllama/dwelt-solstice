extends Node

const LIB_PATH = "res://lib/effect/library/"

# Short to get effect parameter
func get_param(id: String) -> EffectParameter:
	return(EffectLibrary.effects[id])

var effects = { }
var _c := 0 # effect count, for debugging

func _init() -> void:
	for _f in DirAccess.get_files_at(LIB_PATH):
		effects[_f.replace(".tres", "")] = load(LIB_PATH + _f)
		_c += 1

func _ready() -> void:
	await get_tree().process_frame
	Utils.pdebug("Loaded " + str(_c) + " effect parameter(s).", "EffectLibrary")
