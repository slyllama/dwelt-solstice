extends Node

const LIB_PATH = "res://lib/effect/library/"

# Short to get effect parameter
func get_param(id: String) -> EffectParameter:
	return(EffectLibrary.effects[id])

var effects = { }

func _init() -> void:
	for _f in DirAccess.get_files_at(LIB_PATH):
		effects[_f.replace(".tres", "")] = load(LIB_PATH + _f)
		print(effects)
