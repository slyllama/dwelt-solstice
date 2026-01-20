extends ColorRect

func set_state(state: float) -> void:
	var _e = ease(state, 3.0) # eased state provides a little snappiness
	material.set_shader_parameter("state", _e)

func disappear(speed := 1.3) -> void:
	var _t = create_tween()
	_t.tween_method(set_state, 0.0, 1.0, speed)

func _ready() -> void:
	set_state(0.0)
	disappear()
