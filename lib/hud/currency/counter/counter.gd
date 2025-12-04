@tool
extends HBoxContainer

@export var icon: Texture2D:
	get: return(icon)
	set(_icon):
		icon = _icon
		$Icon.texture = icon

@export var value := 0:
	get: return(value)
	set(_value):
		value = _value
		$Amount.text = str(value)

@export var tint := Color.WHITE:
	get: return(tint)
	set(_tint):
		tint = _tint
		$Icon.modulate = tint
