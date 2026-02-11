extends Marker3D

@export var vertical_offset := 0.4
@export var view_length := 1.1
@export var view_sensitivity := 0.75

@onready var target_zoom: float = $Camera.position.z
@onready var target_x_rotation := rotation.x
@onready var target_y_rotation := global_rotation.y

var _event_relative := Vector2.ZERO
var _last_click_position := Vector2.ZERO

func _ready() -> void:
	Dwelt.camera = $Camera
	top_level = true
	$Camera.top_level = true

func _input(event: InputEvent) -> void:
	# Release input capture on escape
	if Input.is_action_just_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		get_window().warp_mouse(_last_click_position)
	
	# Recapture input on click
	if (Input.is_action_just_pressed("left_click")
		and !get_window().gui_get_hovered_control()):
		_last_click_position = get_window().get_mouse_position()
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	if (event is InputEventMouseMotion
		and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED):
		_event_relative = event.relative * view_sensitivity

func _physics_process(_delta: float) -> void:
	var _last_event_relative := _event_relative
	
	if $OrbitStartDelay.is_stopped():
		target_x_rotation -= _event_relative.y * 0.01
		target_y_rotation -= _event_relative.x * 0.01
		target_x_rotation = clamp(
			target_x_rotation, deg_to_rad(-80), deg_to_rad(30))
		rotation.x = lerp_angle(rotation.x,
			target_x_rotation, Utils.crit_lerp(20.0))
		rotation.y = lerp_angle(rotation.y,
			target_y_rotation, Utils.crit_lerp(20.0))
	
	global_position = lerp(
		global_position,
		get_parent().global_position + Vector3(0, 1, 0) * vertical_offset,
		Utils.crit_plerp(10.0))
	
	# Handle camera view_length
	$SpringArm.spring_length = lerp($SpringArm.spring_length,
		view_length, Utils.crit_plerp(10.0))
	
	$Camera.global_position = $SpringArm/CameraAnchor.global_position
	$Camera.global_rotation = $SpringArm/CameraAnchor.global_rotation
	
	if _event_relative == _last_event_relative:
		_event_relative = Vector2.ZERO # prevent runaway orbiting
