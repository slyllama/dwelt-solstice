extends Marker3D

@export var zoom_increment = 0.35
@export var zoom_smoothness = 6.0
@export var min_zoom = 1.5
@export var max_zoom = 6.0

@onready var target_zoom = $Camera.position.z

func _ready() -> void:
	Dwelt.camera = $Camera

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("zoom_in"):
		target_zoom -= zoom_increment
	if Input.is_action_just_pressed("zoom_out"):
		target_zoom += zoom_increment

func _physics_process(_delta: float) -> void:
	# Smooth camera movement
	global_position = lerp(global_position,
		get_parent().global_position, Utils.crit_plerp(10.0))
	
	# Handle camera zoom
	target_zoom = clamp(target_zoom, min_zoom, max_zoom)
	$Camera.position.z = lerp($Camera.position.z,
		target_zoom, Utils.crit_plerp(zoom_smoothness))
