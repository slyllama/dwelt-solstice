extends Node3D

@export var shard_name := "Shard"
@export var master_light: DirectionalLight3D

func _ready() -> void:
	Settings.changed.connect(func(_s: String):
		if _s == "bloom":
			if %Sky.environment:
				%Sky.environment.glow_enabled = Utils.b(Settings.data.bloom)
		elif _s == "shadows":
			if master_light:
				var _shadow_quality = Settings.data.shadows
				match _shadow_quality:
					"off":
						master_light.shadow_enabled = false
					"low":
						master_light.shadow_enabled = true
						master_light.directional_shadow_mode = DirectionalLight3D.SHADOW_ORTHOGONAL
					"high":
						master_light.shadow_enabled = true
						master_light.directional_shadow_mode = DirectionalLight3D.SHADOW_PARALLEL_4_SPLITS
					_: # medium
						master_light.shadow_enabled = true
						master_light.directional_shadow_mode = DirectionalLight3D.SHADOW_PARALLEL_2_SPLITS
		)
	
	Save.load_file()
	Settings.load_file()
	
	await get_tree().create_timer(1.0).timeout
	$HUD.play_title_card(shard_name)
