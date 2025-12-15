extends CharacterBody3D

@export var speed := 3.0
@export var friction := 15.0
@export var gravity_damping := 10.0
var _target_velocity := Vector3.ZERO
var _target_y_rotation := 0.0
var _target_y_position := 0.0

var _moving := false
signal move_started
signal move_stopped

@onready var _initial_y_rotation = $Orbit.rotation.y

func _ready() -> void:
	Dwelt.player = self
	move_started.connect(func(): $RobotMesh/Sound.move_vol = 0.37)
	move_stopped.connect(func(): $RobotMesh/Sound.move_vol = 0.0)

func _physics_process(_delta: float) -> void:
	_target_velocity = Vector3.ZERO
	var _camera_basis = $Orbit.global_transform.basis
	
	# Calculate basis and move player based on player input
	var _basis_x: Vector3 = Vector3.RIGHT * _camera_basis * Vector3(1, 0, -1)
	var _basis_z: Vector3 = Vector3.FORWARD * _camera_basis * Vector3(-1, 0, 1)
	_target_velocity += _basis_z * %InputHandler.direction.z * speed
	_target_velocity += _basis_x * %InputHandler.direction.x * speed
	velocity = lerp(velocity, _target_velocity, Utils.crit_plerp(friction))
	
	# Apply gravity and hover
	var _y_diff = $YCast.global_position.y - $YCast.get_collision_point().y
	var _y_target = abs($YCast.target_position.y)
	if !$YCast.is_colliding(): # apply gravity even if beyond raycast height
		_y_diff = _y_target
	velocity.y += Dwelt.GRAVITY / gravity_damping
	if _y_diff < _y_target: velocity.y += _y_target - _y_diff
	
	move_and_slide()
	
	# Get rotation from input direction and apply it to player mesh
	if %InputHandler.direction.length() > 0:
		_target_y_rotation = $Orbit.rotation.y - _initial_y_rotation
	$RobotMesh.rotation.y = lerp_angle($RobotMesh.rotation.y,
		_target_y_rotation, Utils.crit_plerp(5.0))
	
	if Vector3(velocity * Vector3(1, 0, 1)).length() > 1.0:
		$RobotMesh/Stars.amount_ratio = 1.0
		if !_moving:
			_moving = true
			move_started.emit()
			_target_y_position = 0.1
	else:
		$RobotMesh/Stars.amount_ratio = 0.25
		if _moving:
			_moving = false
			move_stopped.emit()
			_target_y_position = 0.0
	
	$RobotMesh.position.y = lerp($RobotMesh.position.y,
		_target_y_position, Utils.crit_plerp(4.0))
	
	# Send animation parameters to the mesh for animation blending
	$RobotMesh.forward_blend = %InputHandler.direction.z
	$RobotMesh.strafe_blend = %InputHandler.direction.x
