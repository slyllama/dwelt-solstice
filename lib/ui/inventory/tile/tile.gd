class_name InventoryTile extends TextureRect

const TEX_PATH := "res://lib/ui/inventory/tile/textures/"
const BLANK_TEX := preload("res://generic/materials/textures/tile_diff.jpg")
const DRAG_THRESHOLD := 20.0

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

var _last_click_position := Vector2.ZERO
var _drag_threshold_passed := true

# This is for static tiles (like the cursor) which aren't freed and remade
func reset() -> void:
	texture = BLANK_TEX

func _init() -> void:
	custom_minimum_size = Vector2(64.0, 64.0)
	expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	texture = BLANK_TEX

func _ready() -> void:
	# TODO: debug - allows to see indices
	var _l = Label.new()
	_l.text = str(index)
	_l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_l.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_l.mouse_filter = Control.MOUSE_FILTER_PASS
	_l.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(_l)

func _gui_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("left_click"):
		_last_click_position = get_window().get_mouse_position()
		_drag_threshold_passed = false
	if Input.is_action_pressed("left_click"):
		var _d = get_window().get_mouse_position() - _last_click_position # mouse delta
		if !_drag_threshold_passed:
			if _d.length() > DRAG_THRESHOLD:
				_drag_threshold_passed = true
				drag_initiated.emit()
