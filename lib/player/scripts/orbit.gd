extends Marker3D

@export var zoom_increment := 0.35
@export var zoom_smoothness := 6.0
@export var vertical_offset := 0.35
@export var min_zoom := 1.0
@export var max_zoom := 1.5

@onready var target_zoom: float = $Camera.position.z
@onready var target_x_rotation := rotation.x
@onready var target_y_rotation := global_rotation.y

func _ready() -> void:
	Dwelt.camera = $Camera
	top_level = true
	$Camera.top_level = true

func _input(event: InputEvent) -> void:
	# Don't zoom when hovering over UI
	if get_window().gui_get_hovered_control(): return
	if event is InputEventPanGesture:
		target_zoom += event.delta.y
	
	if Input.is_action_just_pressed("zoom_in"):
		target_zoom -= zoom_increment
	if Input.is_action_just_pressed("zoom_out"):
		target_zoom += zoom_increment

func _physics_process(_delta: float) -> void:
	# Get the player's zoom ratio between the closest and farthest zoom point
	var _zoom_ratio = ($SpringArm.spring_length - min_zoom) / (max_zoom - min_zoom)
	
	target_x_rotation -= $PanHandler.event_relative.y * 0.01
	target_y_rotation -= $PanHandler.event_relative.x * 0.01
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
	target_zoom = clamp(target_zoom, min_zoom, max_zoom)
	$SpringArm.spring_length = lerp($SpringArm.spring_length,
		target_zoom, Utils.crit_plerp(zoom_smoothness))
	
	$Camera.global_position = $SpringArm/CameraAnchor.global_position
	$Camera.global_rotation = $SpringArm/CameraAnchor.global_rotation
