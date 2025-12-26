@tool
extends Control

@export var capacity := 15 # total space
@export var tile_width := 5 # should be a multiple of capacity

var dragged_tile_id
var dragged_tile_idx

# We copy the player's inventory data so we can perform operations on it like
# showing temporary states during dragging
@onready var inventory_data := {}

# Reset the drag cursor
func _clear_drag_cursor() -> void:
	dragged_tile_id = null
	dragged_tile_idx = null
	%CursorTile.id = "blank"
	%CursorTile.visible = false

# Remove blank slots from the inventory array - helps keep the save file clean
func _trim_inventory() -> void:
	for _item in inventory_data:
		if inventory_data[_item].id == "blank":
			inventory_data.erase(_item)

func appear(muted := false) -> void:
	if !muted: # conserve insanity during debugging
		$Open.play()
		$DissolveHelper.appear()

func disappear() -> void:
	$Open.play()
	$DissolveHelper.disappear()

func begin_drag(id: String, idx: int) -> void:
	Dwelt.ui_click.emit()
	
	%CursorTile.reset()
	inventory_data[str(idx)].id = "blank"
	dragged_tile_id = id
	dragged_tile_idx = idx
	%CursorTile.id = id
	%CursorTile.visible = true
	render() # render a tempory inventory with the dragged element removed

func complete_drag(dest_idx: int) -> void:
	$DragComplete.play()
	
	var _drag_sidx = str(dragged_tile_idx)
	var _dest_sidx = str(dest_idx)
	
	inventory_data[_drag_sidx] = {} # allocate entry for source
	if _dest_sidx in Save.data.inventory: # copy the destination to the source, if there is one...
		inventory_data[_drag_sidx].id = Save.data.inventory[_dest_sidx].id
	else: #...or clear the source if the destination was blank
		inventory_data[_drag_sidx].id = "blank"
	inventory_data[_dest_sidx] = {} # allocate entry for destination
	inventory_data[_dest_sidx].id = dragged_tile_id # assign the already-known source to the destination
	
	_clear_drag_cursor()
	_trim_inventory()
	Save.data.inventory = inventory_data.duplicate()
	render()
	
	Save.save_to_file()

# Revert to original layout
func cancel_drag() -> void:
	_clear_drag_cursor()
	inventory_data = Save.data.inventory.duplicate()
	render() 

func render() -> void:
	for _n in $Box/VBox.get_children():
		_n.queue_free() # reset
	
	# Calculate the number of rows to render
	var row_count := 0
	var _c = capacity
	while _c > 0:
		_c -= tile_width
		row_count += 1
	
	for _r in row_count:
		# Render individual rows
		var row = HBoxContainer.new()
		row.use_parent_material = true
		row.add_theme_constant_override("separation", 2)
		$Box/VBox.add_child(row)
		
		for _t in tile_width:
			# Render individual tiles
			var tile = InventoryTile.new()
			var _idx = _r * tile_width + _t
			tile.index = _idx # assign index
			if str(_idx) in inventory_data: # assign item if the player has one saved
				tile.id = inventory_data[str(_idx)].id
			row.add_child(tile)
			
			tile.drag_initiated.connect(func(): # begin dragging
				inventory_data.erase(tile.index)
				begin_drag(tile.id, tile.index))

func _ready() -> void:
	$DissolveHelper._set_dissolve(0.0)
	render()
	
	if Engine.is_editor_hint():
		appear(true) # debugging
	else: visible = false

func _input(_event: InputEvent) -> void:
	if Engine.is_editor_hint(): return
	inventory_data = Save.data.inventory.duplicate()
	if Input.is_action_just_released("left_click"):
		if dragged_tile_id:
			if get_window().gui_get_hovered_control():
				var _p = get_window().gui_get_hovered_control()
				if _p is InventoryTile:
					var _idx = _p.index
					complete_drag(_idx)
				else: cancel_drag() # didn't land on a tile
			else: cancel_drag() # landed outside of the UI
		else: cancel_drag() # nothing to drag

func _process(_delta: float) -> void:
	if Engine.is_editor_hint(): return
	if Input.is_action_pressed("left_click"):
		%CursorTile.position = (get_viewport().get_mouse_position()
			- %CursorTile.size / 2.0)
