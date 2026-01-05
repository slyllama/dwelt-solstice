@tool
extends EditorPlugin

func _get_selection() -> Array:
	return(get_editor_interface().get_selection().get_selected_nodes())

func _get_root() -> Node:
	return(get_editor_interface().get_edited_scene_root())

func get_all_children(node: Node, arr := []) -> Array:
	arr.push_back(node)
	for _child in node.get_children():
		arr = get_all_children(_child, arr)
	return(arr)

func select_all_foliage() -> void:
	for _n in get_all_children(_get_root()):
		if _n is FoliageSpawner:
			get_editor_interface().get_selection().add_node(_n)

func select_similar_foliage() -> void:
	if _get_selection().size() > 0:
		if _get_selection()[0] is FoliageSpawner:
			var _mesh = _get_selection()[0].foliage_mesh
			for _n in get_all_children(_get_root()):
				if _n is FoliageSpawner:
					if _n.foliage_mesh == _mesh:
						get_editor_interface().get_selection().add_node(_n)

func render_selected_foliage() -> void:
	for _n in _get_selection():
		if _n is FoliageSpawner:
			_n.render()

func _enable_plugin() -> void: pass

func _disable_plugin() -> void: pass

func _enter_tree() -> void:
	add_tool_menu_item("Select All Foliage", select_all_foliage)
	add_tool_menu_item("Select Similar Foliage", select_similar_foliage)
	add_tool_menu_item("Render Selected Foliage", render_selected_foliage)

func _exit_tree() -> void:
	remove_tool_menu_item("Select All Foliage")
	remove_tool_menu_item("Select Similar Foliage")
	remove_tool_menu_item("Render Selected Foliage")
