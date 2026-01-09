@tool
extends EditorScenePostImport

# Meshes in Blender with this keyword will have the decal layer mask added
const BASE_KEYWORD = "_Base"

func _post_import(scene):
	iterate(scene)
	return(scene)

func iterate(node):
	if node != null:
		if node is StaticBody3D:
			node.set_collision_layer_value(2, true)
		for child in node.get_children():
			if "_Base" in child.name and child is MeshInstance3D:
				var _c: MeshInstance3D = child
				_c.set_layer_mask_value(3, true)
			iterate(child)
