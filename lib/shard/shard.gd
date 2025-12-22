extends Node3D

@export var shard_name := "Shard"

func _ready() -> void:
	Settings.changed.connect(func(_s: String):
		if _s == "bloom":
			if %Sky.environment:
				%Sky.environment.glow_enabled = Utils.b(Settings.data.bloom))
	
	Save.load_file()
	Settings.load_file()
	
	await get_tree().create_timer(1.0).timeout
	$HUD.play_title_card(shard_name)
