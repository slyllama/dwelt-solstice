extends Marker3D

@export var vertical_offset := 0.35
@export var zoom := 1.3

@onready var target_zoom: float = $Camera.position.z
@onready var target_x_rotation := rotation.x
@onready var target_y_rotation := global_rotation.y

var _event_relative := Vector2.ZERO

func _ready() -> void:
	Dwelt.camera = $Camera
	top_level = true
	$Camera.top_level = true
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		_event_relative = event.relative

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
	
	# Handle camera zoom
	$SpringArm.spring_length = lerp($SpringArm.spring_length,
		zoom, Utils.crit_plerp(10.0))
	
	$Camera.global_position = $SpringArm/CameraAnchor.global_position
	$Camera.global_rotation = $SpringArm/CameraAnchor.global_rotation
	
	if _event_relative == _last_event_relative:
		_event_relative = Vector2.ZERO # prevent runaway orbiting
