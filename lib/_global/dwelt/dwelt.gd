extends Node

const GRAVITY := -9.8

signal ui_click
signal window_adjusted # called when retina is detected

# References
var camera: Camera3D
var player: CharacterBody3D

func _ready() -> void:
	# Signal connections
	ui_click.connect($UIClick.play)
