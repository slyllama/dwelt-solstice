extends Node3D

@export var look_target: Node3D
var forward_blend := 0.0
var _target_forward_blend := 0.0

var _ns_count := 0 # no shadows count

func _ready() -> void:
	for _n in Utils.get_all_children($Armature/Skeleton3D):
		if _n is MeshInstance3D and "Glow" in _n.name:
			_n.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
			_ns_count += 1
	Utils.pdebug("Removed shadows for " 
		+ str(_ns_count) + " meshes.", "Player/RobotMesh")

func _physics_process(_delta: float) -> void:
	# Handle animation blending
	_target_forward_blend = lerp(_target_forward_blend,
		forward_blend, Utils.crit_plerp(9.0))
	$Anim.set("parameters/blend_forward/blend_amount", _target_forward_blend)
