@tool
extends EditorScenePostImport

func _post_import(scene):
	iterate(scene)
	return(scene)

func iterate(node):
	if node != null:
		if node is StaticBody3D:
			node.set_collision_layer_value(2, true)
		for child in node.get_children():
			iterate(child)
