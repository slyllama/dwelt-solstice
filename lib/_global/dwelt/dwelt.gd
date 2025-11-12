extends Node

func _ready() -> void:
	if DisplayServer.screen_get_size().x > 2000:
		# Retina
		get_window().content_scale_factor = 2.0
