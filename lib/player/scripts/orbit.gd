extends Marker3D

@export var zoom_increment = 0.35
@export var zoom_smoothness = 6.0
@export var min_zoom = 0.2
@export var max_zoom = 5.0

@onready var target_zoom = $Camera.position.z

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("zoom_in"):
		target_zoom -= zoom_increment
	if Input.is_action_just_pressed("zoom_out"):
		target_zoom += zoom_increment

func _physics_process(_delta: float) -> void:
	# Handle camera zoom
	target_zoom = clamp(target_zoom, min_zoom, max_zoom)
	$Camera.position.z = lerp($Camera.position.z,
		target_zoom, Utils.crit_plerp(zoom_smoothness))
