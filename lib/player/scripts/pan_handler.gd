extends Node

var _last_click_position := Vector2.ZERO
var _last_click_in_gui := false
var event_relative := Vector2.ZERO
var pan_speed_scaling := 1.0

func _ready() -> void:
	Dwelt.window_adjusted.connect(func():
		pan_speed_scaling = (1.0
			/ get_window().content_scale_factor))

func _input(event: InputEvent) -> void:
	if Input.is_action_just_released("left_click"):
		_last_click_in_gui = false
	
	if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
		if Input.is_action_just_pressed("left_click"):
			if get_window().gui_get_hovered_control():
				_last_click_in_gui = true
			_last_click_position = get_window().get_mouse_position()
	elif Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		if Input.is_action_just_released("left_click"):
			# We need to wait a frame so that nodes like the
			await get_tree().process_frame
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			get_window().warp_mouse(_last_click_position)
		if Input.is_action_pressed("left_click"):
			if event is InputEventMouseMotion:
				event_relative = event.relative

func _process(_delta: float) -> void:
	if Input.is_action_pressed("left_click") and !_last_click_in_gui:
			var _m := get_window().get_mouse_position()
			var _mouse_delta := _last_click_position - _m
			if _mouse_delta.length() > 10.0:
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	var _last_event_relative = event_relative
	if event_relative == _last_event_relative:
		event_relative = Vector2.ZERO
