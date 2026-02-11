class_name GadgetGridLoader extends Node3D
# Manages grid gadgets, loading and saving them to the player's save file
# and updating the grid

const UNKNOWN_GADGET := "res://gadgets/_unknown/_unknown.tscn" # error gadget
const GRID_UNIT_SIZE := 1.0 # the actual world size of a grid unit

# Spawn a single grid gadget
func spawn_grid_gadget(data: Dictionary) -> bool:
	var success := true
	
	# Load ID, substituting error gadget if an ID hasn't been specified
	var id: String
	if "id" in data:
		id = data.id
	else:
		success = false
		id = "_unknown"
	
	# Load path, substituting error gadget if the path doesn't exist
	var path: String = Dwelt.GADGET_PATH + id + "/" + id + ".tscn"
	if !FileAccess.file_exists(path):
		success = false
		path = UNKNOWN_GADGET
	
	var gadget: Gadget = load(path).instantiate()
	
	# Unwrap the gadget's grid position to get its actual world coordinates
	if "grid_position" in data:
		var grid_position := Vector3i(
			Utils.unwrap_vec3_str(data.grid_position))
		gadget.position = grid_position * GRID_UNIT_SIZE
	else: success = false
	
	if "grid_rotation" in data:
		var grid_rotation := deg_to_rad(float(data.grid_rotation))
		gadget.rotation.y = grid_rotation
	else: success = false
	
	add_child(gadget)
	return(success) # if any check fails, a `false` is returned

# Load grid gadgets into the world, by calling `spawn_grid_gadget`
# for each gadget data in the collection
func load_grid_gadgets(data_collection: Array) -> void:
	var count := data_collection.size()
	var errors := 0 # incremented if `spawn_grid_gadget` returns a failure
	
	for grid_gadget_data in data_collection:
		var spawn_outcome = spawn_grid_gadget(grid_gadget_data)
		if !spawn_outcome: errors += 1
	Utils.pdebug("Loaded " + str(count) + " grid gadget(s)"
		+ " with " + str(errors) + " error(s).", "GadgetGridManager")

func _init() -> void:
	Save.loaded.connect(func():
		# Only attempt to load grid gadgets if they exist in the save
		if "grid_gadgets" in Save.data:
			load_grid_gadgets(Save.data.grid_gadgets))
