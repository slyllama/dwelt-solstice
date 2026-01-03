@tool
extends Node3D

@export var size := 5.0:
	get: return(size)
	set(_val):
		size = _val
		for _n: Marker3D in get_children():
			var _b: StaticBody3D = _n.get_node("Boundary")
			_b.position.x = -size
		var wall: MeshInstance3D = $B/Boundary/VisualBounds
		var mesh: QuadMesh = wall.mesh
		var mat: ShaderMaterial = wall.get_active_material(0)
		mesh.size = Vector2(size * 2.0, size * 2.0)
		mat.set_shader_parameter("bands_uv_scale", 16.0 * size)

func _ready() -> void:
	visible = true
