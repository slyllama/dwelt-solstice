extends Node

const GRAVITY = -9.8

# References
var camera: Camera3D
var player: CharacterBody3D

func _ready() -> void:
	if DisplayServer.screen_get_size().x > 2000:
		get_window().content_scale_factor = 2.0
