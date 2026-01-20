extends Node3D

@export var shard_name := "Shard"
@export var sun: DirectionalLight3D

func _ready() -> void:
	Settings.changed.connect(func(_s: String):
		if _s == "bloom":
			if %Sky.environment:
				%Sky.environment.glow_enabled = Utils.b(Settings.data.bloom)
		elif _s == "shadows":
			if sun:
				var _shadow_quality = Settings.data.shadows
				match _shadow_quality:
					"off":
						sun.shadow_enabled = false
					"low":
						sun.shadow_enabled = true
						sun.directional_shadow_mode = DirectionalLight3D.SHADOW_ORTHOGONAL
					"high":
						sun.shadow_enabled = true
						sun.directional_shadow_mode = DirectionalLight3D.SHADOW_PARALLEL_4_SPLITS
					_: # medium
						sun.shadow_enabled = true
						sun.directional_shadow_mode = DirectionalLight3D.SHADOW_PARALLEL_2_SPLITS
		)
	
	Save.load_file()
	Settings.load_file()
