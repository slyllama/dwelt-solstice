extends Node3D

func _ready() -> void:
	Settings.changed.connect(func(_s: String):
		if _s == "bloom":
			if %Sky.environment:
				%Sky.environment.glow_enabled = Utils.b(Settings.data.bloom))
	
	Save.load_file()
	Settings.load_file()
