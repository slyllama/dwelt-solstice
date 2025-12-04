extends Marker3D

@export var zoom_increment = 0.35
@export var zoom_smoothness = 6.0
@export var min_zoom = 1.2
@export var max_zoom = 4.0

@onready var target_zoom = $Camera.position.z
@onready var target_x_rotation = rotation.x
@onready var target_y_rotation = global_rotation.y

func _ready() -> void:
	Dwelt.camera = $Camera
	top_level = true

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("zoom_in"):
		target_zoom -= zoom_increment
	if Input.is_action_just_pressed("zoom_out"):
		target_zoom += zoom_increment

func _physics_process(_delta: float) -> void:
	target_x_rotation -= $PanHandler.event_relative.y * 0.01
	target_y_rotation -= $PanHandler.event_relative.x * 0.01
	target_x_rotation = clamp(
		target_x_rotation, deg_to_rad(-80), deg_to_rad(30))
	rotation.x = lerp_angle(rotation.x,
		target_x_rotation, Utils.crit_lerp(20.0))
	rotation.y = lerp_angle(rotation.y,
		target_y_rotation, Utils.crit_lerp(20.0))
	
	# Smooth camera movement
	global_position = lerp(global_position,
		get_parent().global_position, Utils.crit_plerp(10.0))
	
	# Handle camera zoom
	target_zoom = clamp(target_zoom, min_zoom, max_zoom)
	$Camera.position.z = lerp($Camera.position.z,
		target_zoom, Utils.crit_plerp(zoom_smoothness))
