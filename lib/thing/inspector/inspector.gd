extends TextureRect

const TEX_PATH = "res://lib/thing/inspector/textures/"
const OWNER_PLAYER_TEX = preload(TEX_PATH + "owner_player.png")
const OWNER_ENEMY_TEX = preload(TEX_PATH + "owner_enemy.png")

# Functions to help control dissolve shader
func _set_dissolve(value: float) -> void: material.set_shader_parameter("value", value)
func _get_dissolve() -> float: return(material.get_shader_parameter("value"))

func appear() -> void:
	update() # render data
	visible = true
	var _d := create_tween()
	_d.tween_method(_set_dissolve,
		_get_dissolve(), 1.0, 0.17)

func disappear() -> void:
	var _d := create_tween()
	_d.tween_method(_set_dissolve,
		_get_dissolve(), 0.0, 0.17)
	_d.tween_callback(func(): visible = false)

func release_target() -> void:
	Dwelt.targeted_thing = null
	await get_tree().process_frame
	if !Dwelt.targeted_thing and visible:
		Utils.pdebug("Releasing target.", "Inspector")
		disappear()

# Render the correct Thing data for the targeted Thing
func update() -> void:
	var _t := Dwelt.targeted_thing
	$Title.text = _t.data.thing_name
	if _t.owned_by_player: $Owner.texture = OWNER_PLAYER_TEX
	else: $Owner.texture = OWNER_ENEMY_TEX

func _init() -> void:
	visible = false
	Dwelt.thing_targeted.connect(appear)

func _ready() -> void:
	_set_dissolve(0.0)

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_released("left_click"):
		if (Input.mouse_mode == Input.MOUSE_MODE_VISIBLE
			and !get_window().gui_get_hovered_control()):
			release_target()
