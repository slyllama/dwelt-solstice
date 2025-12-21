extends Node

const GRAVITY := -9.8

signal play_voice(emotion: String)
signal thing_targeted
signal ui_click
signal window_adjusted # called when retina is detected

# References
var camera: Camera3D
var player: CharacterBody3D

var hovered_thing: Thing
var targeted_thing: Thing

func target_thing(thing: Thing) -> void:
	targeted_thing = thing
	thing_targeted.emit()
	if targeted_thing: # don't play a voice on deselection
		Dwelt.play_voice.emit()

func _ready() -> void:
	# Signal connections
	ui_click.connect($UIClick.play)
