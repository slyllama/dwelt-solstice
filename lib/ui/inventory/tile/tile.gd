class_name InventoryTile extends TextureRect

const TEX_PATH := "res://lib/ui/inventory/tile/textures/"
const BLANK_TEX := preload("res://generic/materials/textures/tile_diff.jpg")
const DRAG_THRESHOLD := 20.0
const DEFAULT_MODULATE := Color(0.8, 0.8, 0.8)

signal drag_initiated

@export var index: int # aligns with how the player's inventory is saved
@export var id := "blank":
	get: return(id)
	set(_id):
		id = _id
		if id:
			if id == "blank": return
			# WARNING: this is inefficient, inventory tiles could probably be cached
			var _tex_path = TEX_PATH + id + ".jpg"
			if FileAccess.file_exists(_tex_path):
				texture = load(_tex_path)
@export var lock_hover := false

var _last_click_position := Vector2.ZERO
var _drag_threshold_passed := true

# Visual effects for hovering and unhovering
func _hover() -> void:
	if id == "blank": return # unassigned tiles are exempt from this
	modulate = Color(1.0, 1.0, 1.0)

func _unhover() -> void:
	if lock_hover: return
	modulate = DEFAULT_MODULATE

# This is for static tiles (like the cursor) which aren't freed and remade
func reset() -> void:
	modulate = Color(1.0, 1.0, 1.0)
	texture = BLANK_TEX

func _init() -> void:
	# Setup
	use_parent_material = true
	custom_minimum_size = Vector2(64.0, 64.0)
	expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	texture = BLANK_TEX
	modulate = DEFAULT_MODULATE

func _ready() -> void:
	mouse_entered.connect(_hover)
	mouse_exited.connect(_unhover)
	
	# TODO: debug - allows to see indices
	var _l = Label.new()
	_l.text = str(index)
	_l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_l.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_l.mouse_filter = Control.MOUSE_FILTER_PASS
	_l.use_parent_material = true
	_l.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(_l)

func _gui_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("left_click"):
		_last_click_position = get_window().get_mouse_position()
		_drag_threshold_passed = false
	if Input.is_action_pressed("left_click"):
		var _d = get_window().get_mouse_position() - _last_click_position # mouse delta
		if !_drag_threshold_passed and id != "blank": # a blank tile cannot be moved
			if _d.length() > DRAG_THRESHOLD:
				_drag_threshold_passed = true
				drag_initiated.emit()
