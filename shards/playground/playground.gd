extends Node3D

func _ready() -> void:
	$Landscape/Col.set_collision_layer_value(2, true)
