extends "res://lib/shard/shard.gd"

func _ready() -> void:
	super()
	$Landscape/Col.set_collision_layer_value(2, true)
