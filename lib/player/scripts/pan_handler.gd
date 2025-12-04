extends Node

var _last_click_position := Vector2.ZERO
var event_relative := Vector2.ZERO

func _input(event: InputEvent) -> void:
	if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
		if Input.is_action_just_pressed("left_click"):
			_last_click_position = get_window().get_mouse_position()
			if get_window().gui_get_hovered_control(): return
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	elif Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		if Input.is_action_just_released("left_click"):
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			get_window().warp_mouse(_last_click_position)
		
		if Input.is_action_pressed("left_click"):
			if event is InputEventMouseMotion:
				event_relative = event.relative

func _process(_delta: float) -> void:
	var _last_event_relative = event_relative
	if event_relative == _last_event_relative:
		event_relative = Vector2.ZERO
