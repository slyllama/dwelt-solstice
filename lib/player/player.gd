extends CharacterBody3D

@export var speed := 3.0
@export var friction := 15.0
@export var gravity_damping := 10.0
var _target_velocity := Vector3.ZERO
var _target_y_rotation := 0.0

var _moving := false
signal move_started
signal move_stopped

func _ready() -> void:
	Dwelt.player = self
	
	$RobotMesh/EngineIdle.play()
	move_started.connect(func():
		$RobotMesh/EngineIdle.stop()
		$RobotMesh/EngineMoving.play())
	move_stopped.connect(func():
		$RobotMesh/EngineMoving.stop()
		$RobotMesh/EngineIdle.play())

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
		print("colliding")
		_y_diff = _y_target
	velocity.y += Dwelt.GRAVITY / gravity_damping
	if _y_diff < _y_target: velocity.y += _y_target - _y_diff
	
	move_and_slide()
	
	# Get rotation from input direction and apply it to player mesh
	if %InputHandler.direction.length() > 0:
		_target_y_rotation = $Orbit.rotation.y + PI
		
		#var _x = %InputHandler.direction.x
		#var _z = %InputHandler.direction.z
		#var _a = atan2(_z, _x) + PI / 2.0 + $Orbit.rotation.y
		#_target_y_rotation = _a
	$RobotMesh.rotation.y = lerp_angle($RobotMesh.rotation.y,
		_target_y_rotation, Utils.crit_plerp(7.0))
	
	if Vector3(velocity * Vector3(1, 0, 1)).length() > 1.0:
		$RobotMesh/Stars.amount_ratio = 1.0
		if !_moving:
			_moving = true
			move_started.emit()
	else:
		$RobotMesh/Stars.amount_ratio = 0.25
		if _moving:
			_moving = false
			move_stopped.emit()
	
	# Send animation parameters to the mesh for animation blending
	$RobotMesh.forward_blend = %InputHandler.direction.length()
