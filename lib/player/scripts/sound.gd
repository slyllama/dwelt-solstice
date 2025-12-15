extends Node3D

var move_vol := 0.0
var _actual_move_sound_volume := 0.0

func _process(_delta: float) -> void:
	# Apply movement sound
	_actual_move_sound_volume = lerp(
		_actual_move_sound_volume,
		move_vol, Utils.crit_lerp(8.0))
	$EngineMoving.volume_linear = _actual_move_sound_volume
