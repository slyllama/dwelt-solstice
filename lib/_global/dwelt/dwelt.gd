extends Node

const GRAVITY := -9.8

enum Aspects { ARCANE, MALEFICENT, ELEMENTAL, CATACLYSMIC,
	KINETIC, TORPEFYING, VERDANT, NOXIOUS, UNASSIGNED }

const aspect_properties = {
	Aspects.ARCANE: { "name": "Arcane" },
	Aspects.MALEFICENT: { "name": "Maleficent" },
	Aspects.ELEMENTAL: { "name": "Elemental" },
	Aspects.CATACLYSMIC: { "name": "Cataclysmic" },
	Aspects.KINETIC: { "name": "Kinetic" },
	Aspects.TORPEFYING: { "name": "Torpefying" },
	Aspects.VERDANT: { "name": "Verdant" },
	Aspects.NOXIOUS: { "name": "Noxious" },
	Aspects.UNASSIGNED: { "name": "((Unassigned))" } }

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
