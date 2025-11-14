extends Node

const GRAVITY = -9.8

# References
var r_camera: Camera3D
var r_player: CharacterBody3D

func _ready() -> void:
	if DisplayServer.screen_get_size().x > 2000:
		# Retina
		get_window().content_scale_factor = 2.0
