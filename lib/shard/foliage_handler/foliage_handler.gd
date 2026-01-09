extends Node3D
# The foliage handler ensures that shader changes need only be made to
# unique instances of materials

var unique_mats: Array[ShaderMaterial] = []

func get_unique_mats() -> void:
	for _f: FoliageSpawner in get_children():
		if !"foliage_mesh" in _f: return
		var _mat = _f.foliage_mesh.surface_get_material(0)
		if !_mat in unique_mats:
			unique_mats.append(_mat)

func set_fade_distance(get_distance: float) -> void:
	for _mat in unique_mats:
		_mat.set_shader_parameter("fade_length", get_distance - 1.0)

func _ready() -> void:
	get_unique_mats()
	
	Settings.changed.connect(func(_s: String):
		if _s == "foliage_render_distance":
			var _foliage_render_distance: String = Settings.data.foliage_render_distance
			match _foliage_render_distance:
				"low": set_fade_distance(7.0)
				"medium": set_fade_distance(12.0)
				_: set_fade_distance(20.0)
	)
