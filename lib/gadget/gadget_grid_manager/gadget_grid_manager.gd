class_name GadgetGridLoader extends Node3D
# Manages grid gadgets, loading and saving them to the player's save file
# and updating the grid

const GRID_UNIT_SIZE := 1.0 # the actual world size of a grid unit

# Spawn a single grid gadget
func spawn_grid_gadget(grid_gadget_data: Dictionary) -> void:
	var id: String = grid_gadget_data.id
	var path: String = Dwelt.GADGET_PATH + id + "/" + id + ".tscn"
	var gadget: Gadget = load(path).instantiate()
	
	# Unwrap the gadget's grid position to get its actual world coordinates
	var grid_position := Vector3i(
		Utils.unwrap_vec3_str(grid_gadget_data.grid_position))
	gadget.position = grid_position * GRID_UNIT_SIZE
	
	var grid_rotation := deg_to_rad(float(grid_gadget_data.grid_rotation))
	gadget.rotation.y = grid_rotation
	
	add_child(gadget)

# Load grid gadgets into the world, by calling `spawn_grid_gadget`
# for each gadget data in the collection
func load_grid_gadgets(grid_gadget_data_collection: Array) -> void:
	for grid_gadget_data in grid_gadget_data_collection:
		spawn_grid_gadget(grid_gadget_data)

func _init() -> void:
	Save.loaded.connect(func():
		# Only attempt to load grid gadgets if they exist in the save
		if "grid_gadgets" in Save.data:
			load_grid_gadgets(Save.data.grid_gadgets))
