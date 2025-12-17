@tool
extends Control

@export var capacity := 15 # total space
@export var tile_width := 5 # should be a multiple of capacity

# TODO: testing data only - treat this as the player's inventory
var test_inventory_data := {
	0: { "id": "test_green" },
	1: { "id": "test_red" } }
var dragged_tile_id
var dragged_tile_idx

# We copy the player's inventory data so we can perform operations on it like
# showing temporary states during dragging
@onready var inventory_data := test_inventory_data.duplicate()

# Functions to help control dissolve shader
func _set_dissolve(value: float) -> void: material.set_shader_parameter("value", value)
func _get_dissolve() -> float: return(material.get_shader_parameter("value"))

# Reset the drag cursor
func _clear_drag_cursor() -> void:
	dragged_tile_id = null
	dragged_tile_idx = null
	%CursorTile.id = "blank"
	%CursorTile.visible = false

func appear(muted := false) -> void:
	if !muted: # conserve insanity during debugging
		$Open.play()
	visible = true
	var _d = create_tween()
	_d.tween_method(_set_dissolve, _get_dissolve(), 1.0, 0.25)

func disappear() -> void:
	$Open.play()
	_set_dissolve(1.0)
	var _d = create_tween()
	_d.tween_method(_set_dissolve, _get_dissolve(), 0.0, 0.25)
	_d.tween_callback(func(): visible = false)

func begin_drag(id: String, idx: int) -> void:
	Dwelt.ui_click.emit()
	
	%CursorTile.reset()
	dragged_tile_id = id
	dragged_tile_idx = idx
	%CursorTile.id = id
	%CursorTile.visible = true
	render() # render a tempory inventory with the dragged element removed

func complete_drag(dest_idx: int) -> void:
	$DragComplete.play()
	
	inventory_data[dragged_tile_idx] = {} # allocate entry for source
	if dest_idx in test_inventory_data: # copy the destination to the source, if there is one...
		inventory_data[dragged_tile_idx].id = test_inventory_data[dest_idx].id
	else: #...or clear the source if the destination was blank
		inventory_data[dragged_tile_idx].id = "blank"
	inventory_data[dest_idx] = {} # allocate entry for destination
	inventory_data[dest_idx].id = dragged_tile_id # assign the already-known source to the destination
	
	_clear_drag_cursor()
	test_inventory_data = inventory_data.duplicate()
	render()

# Revert to original layout
func cancel_drag() -> void:
	_clear_drag_cursor()
	inventory_data = test_inventory_data.duplicate()
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
			if _idx in inventory_data: # assign item if the player has one saved
				tile.id = inventory_data[_idx].id
			row.add_child(tile)
			
			tile.drag_initiated.connect(func(): # begin dragging
				inventory_data.erase(tile.index)
				begin_drag(tile.id, tile.index))

func _ready() -> void:
	_set_dissolve(0.0)
	render()
	
	if Engine.is_editor_hint():
		appear(true) # debugging
	else:
		visible = false

func _input(_event: InputEvent) -> void:
	if Engine.is_editor_hint(): return
	if Input.is_action_just_released("left_click"):
		if dragged_tile_id:
			if get_window().gui_get_hovered_control():
				var _p = get_window().gui_get_hovered_control().get_parent()
				if _p is InventoryTile:
					var _idx = _p.index
					complete_drag(_idx)
				else: cancel_drag() # didn't land on a tile
			else: cancel_drag() # landed outside of the UI
		else: cancel_drag() # nothing to drag

func _process(_delta: float) -> void:
	%CursorTile.position = (Vector2(DisplayServer.mouse_get_position())
		- %CursorTile.size / 2.0)
