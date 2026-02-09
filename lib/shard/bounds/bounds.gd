@tool
extends Node3D

@export var size := 5.0:
	get: return(size)
	set(_val):
		size = _val

func _ready() -> void:
	visible = false
