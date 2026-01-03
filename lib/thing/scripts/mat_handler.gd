class_name ThingMatHandler extends Node
# mat_handler (ThingMatHandler)
# Handles material operations on Things (like highlighting on hover)
# Does this by building a list of unique materials in the node passed to it

@export var mesh: Node3D:
	get: return(mesh)
	set(_mesh):
		mesh = _mesh
		if mesh: _build_materials_list()

# Create a list of unique materials and instances which can be operated on
var materials: Array[ShaderMaterial]
var geometry_instances: Array[GeometryInstance3D]

func set_highlight(state := true) -> void:
	for _n in geometry_instances:
		_n.set_instance_shader_parameter("highlighted", state)

func set_distance_fade(state := true) -> void:
	for _n in geometry_instances:
		_n.set_instance_shader_parameter("distance_fade", state)

func set_distance_fade_amount(amount: float) -> void:
	for _n in geometry_instances:
		_n.set_instance_shader_parameter("distance_fade_amount", amount)
		_n.visibility_range_end = amount + 1.5
		_n.visibility_range_fade_mode = GeometryInstance3D.VISIBILITY_RANGE_FADE_SELF

func _build_materials_list() -> void:
	for _n in Utils.get_all_children(mesh):
		# Shader instance uniforms get written per-geometry instance and not
		# per-shader material, so we must build this list too
		if !_n is GeometryInstance3D: continue
		geometry_instances.append(_n)
		
		# Add materials
		if !_n.get_active_material(0): continue
		var _m: Material = _n.get_active_material(0)
		if !_m is ShaderMaterial: continue
		if _m in materials: continue
		materials.append(_m) # append
