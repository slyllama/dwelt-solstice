extends Node

var _delta := 0.0
var _pdelta := 0.0

func get_mouse_position() -> Vector2:
	# The mouse position retrieved from the viewport seems offset when in
	# fullscreen modes, so when in fullscreen we get the mouse's actual
	# position from the DisplayServer
	var mouse_pos: Vector2
	if (get_window().mode == Window.MODE_FULLSCREEN
		or get_window().mode == Window.MODE_EXCLUSIVE_FULLSCREEN):
		mouse_pos = (Vector2(DisplayServer.screen_get_position())
			+ Vector2(DisplayServer.mouse_get_position())
			* 1.0 / get_window().content_scale_factor)
	else: mouse_pos = get_viewport().get_mouse_position()
	return(mouse_pos)

func crit_lerp(speed: float) -> float:
	return(clamp(1.0 - exp(-speed * _delta), 0.0, 1.0))

func crit_plerp(speed: float) -> float:
	return(clamp(1.0 - exp(-speed * _pdelta), 0.0, 1.0))

func get_all_children(node: Node, arr := []) -> Array:
	arr.push_back(node)
	for _child in node.get_children():
		arr = get_all_children(_child, arr)
	return(arr)

func pdebug(text: String, source := "") -> void:
	var line := text
	if source != "":
		line = "[" + source + "] " + line
	print(line)

func _process(delta: float) -> void: _delta = delta
func _physics_process(delta: float) -> void: _pdelta = delta
