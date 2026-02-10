@tool
extends "res://lib/shard/shard.gd"

func _ready() -> void:
	$Floor/GrassBase/Floor.set_instance_shader_parameter("grass_base_uv", 18.0)
	$Floor/GrassBase/Floor.set_instance_shader_parameter("grass_blend_uv", 48.0)
	$Floor/GrassBase/Floor/StaticBody3D.set_collision_mask_value(2, true)
	$Floor/GrassBase/Floor/StaticBody3D.set_collision_layer_value(2, true)
	super()
