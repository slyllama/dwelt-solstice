extends ColorRect

@export var disappear_on_start := true

func set_state(state: float) -> void:
	var _e = ease(state, 3.0) # eased state provides a little snappiness
	set_instance_shader_parameter("state", _e)

func appear(speed := 1.3) -> void:
	var _t = create_tween()
	_t.tween_method(
		set_state, get_instance_shader_parameter("state"), 0.5, speed)

func disappear(speed := 1.3) -> void:
	var _t = create_tween()
	_t.tween_method(
		set_state, get_instance_shader_parameter("state"), 1.0, speed)

func _ready() -> void:
	if disappear_on_start:
		set_state(0.0)
		print("doingthis")
		disappear()
	else:
		set_state(1.0) # waiting to be started
