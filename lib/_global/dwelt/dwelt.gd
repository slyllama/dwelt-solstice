extends Node

const GADGET_PATH := "res://gadgets/"
const GRAVITY := -9.8

# Shortcuts
signal play_voice(emotion: String)
signal ui_click

signal window_adjusted # called when retina is detected

# References
var camera: Camera3D
var player: DweltPlayer
var screen_fx: ScreenFX

func _ready() -> void:
	# Signal connections
	ui_click.connect($UIClick.play)
	Settings.changed.connect(func(_s: String):
		if _s == "fps_limit":
			var _fps_limit: String = Settings.data["fps_limit"]
			match _fps_limit:
				"30fps": Engine.max_fps = 30
				"60fps": Engine.max_fps = 60
				"144fps": Engine.max_fps = 144
				_: Engine.max_fps = 0
			)
