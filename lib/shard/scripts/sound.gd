extends Node

func _set_bus_vol(vol: float) -> void:
	AudioServer.set_bus_volume_linear(0, vol)

func _init() -> void:
	# Start muted
	_set_bus_vol(0.0)

func _ready() -> void:
	await get_tree().process_frame
	$Ambience.play()
	var _v = create_tween()
	_v.tween_method(_set_bus_vol, 0.0, 1.0, 1.0)
