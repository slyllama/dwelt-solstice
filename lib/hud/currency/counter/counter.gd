@tool
extends HBoxContainer

@export var id := "none"

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

func _ready() -> void:
	if Engine.is_editor_hint(): return
	Save.loaded.connect(func():
		var _cdata = Save.data.currency # currency data
		if id in _cdata:
			value = int(Save.data.currency[id]))
