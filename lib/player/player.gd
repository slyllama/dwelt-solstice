extends CharacterBody3D

@export var speed := 4.0
@export var friction := 15.0
var _target_velocity := Vector3.ZERO
var _target_y_rotation := 0.0

func _physics_process(_delta: float) -> void:
	_target_velocity = Vector3.ZERO
	var _camera_basis = $Orbit.global_transform.basis
	
	# Calculate basis and move player based on player input
	var _basis_x: Vector3 = Vector3.RIGHT * _camera_basis * Vector3(1, 0, -1)
	var _basis_z: Vector3 = Vector3.FORWARD * _camera_basis * Vector3(-1, 0, 1)
	_target_velocity += _basis_z * %InputHandler.direction.z * speed
	_target_velocity += _basis_x * %InputHandler.direction.x * speed
	velocity = lerp(velocity, _target_velocity, Utils.crit_plerp(friction))
	move_and_slide()
	
	# Get rotation from input direction and apply it to player mesh
	if %InputHandler.direction.length() > 0:
		var _x = %InputHandler.direction.x
		var _z = %InputHandler.direction.z
		var _a = atan2(_z, _x) + PI / 2.0 + $Orbit.rotation.y
		_target_y_rotation = _a
	$RobotMesh.rotation.y = lerp_angle($RobotMesh.rotation.y,
		_target_y_rotation, Utils.crit_plerp(5.0))
	
	# Send animation parameters to the mesh for animation blending
	$RobotMesh.forward_blend = %InputHandler.direction.length()
	
	# Smooth camera movement
	$Orbit.global_position = lerp($Orbit.global_position,
		global_position, Utils.crit_plerp(10.0))
