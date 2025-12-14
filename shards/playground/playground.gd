extends "res://lib/shard/shard.gd"

func _ready() -> void:
	super()
	$Landscape/Col.set_collision_layer_value(2, true)
	
	await get_tree().create_timer(2.0).timeout
	$Sound/Music.play()
