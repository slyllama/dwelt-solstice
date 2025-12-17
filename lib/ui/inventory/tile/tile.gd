class_name InventoryTile extends TextureRect

const TEX_PATH := "res://lib/ui/inventory/tile/textures/"
const TEX_OVERLAY := preload(TEX_PATH + "overlay.png")
const TEX_BLANK := preload(TEX_PATH + "blank.jpg")
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
@export var lock_hover := false

var _last_click_position := Vector2.ZERO
var _drag_threshold_passed := true

# Visual effects for hovering and unhovering
func _hover() -> void:
	if id == "blank": return # unassigned tiles are exempt from this
	modulate = Color(1.3, 1.3, 1.3)

func _unhover() -> void:
	if lock_hover: return
	modulate = Color(1.0, 1.0, 1.0)

# This is for static tiles (like the cursor) which aren't freed and remade
func reset() -> void:
	modulate = Color(1.0, 1.0, 1.0)
	texture = null

func _init() -> void:
	# Setup
	use_parent_material = true
	custom_minimum_size = Vector2(64.0, 64.0)
	expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	texture = TEX_BLANK

func _ready() -> void:
	mouse_entered.connect(_hover)
	mouse_exited.connect(_unhover)
	
	## TODO: debug - allows to see indices
	#var _l = Label.new()
	#_l.text = str(index)
	#_l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	#_l.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	#_l.mouse_filter = Control.MOUSE_FILTER_PASS
	#_l.use_parent_material = true
	#_l.set_anchors_preset(Control.PRESET_FULL_RECT)
	#add_child(_l)
	
	if !id == "blank":
		var _p = TextureRect.new()
		_p.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		_p.texture = TEX_OVERLAY
		_p.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		_p.mouse_filter = Control.MOUSE_FILTER_IGNORE
		_p.use_parent_material = true
		add_child(_p)

func _gui_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("left_click"):
		_last_click_position = get_viewport().get_mouse_position()
		_drag_threshold_passed = false
	if Input.is_action_pressed("left_click"):
		var _d = get_viewport().get_mouse_position() - _last_click_position # mouse delta
		if !_drag_threshold_passed and id != "blank": # a blank tile cannot be moved
			if _d.length() > DRAG_THRESHOLD:
				_drag_threshold_passed = true
				drag_initiated.emit()
