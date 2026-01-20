@tool
extends HBoxContainer

const ICON_CHECKED = preload("res://generic/textures/checked.jpg")
const ICON_UNCHECKED = preload("res://generic/textures/unchecked.jpg")

@export var id := "setting"
@export var title := "((Setting))":
	set(_title):
		title = _title
		$Label.text = title
@export var state := false

func _set_checked(checked := !state) -> void:
	if checked: $Checkbox.texture = ICON_CHECKED
	else: $Checkbox.texture = ICON_UNCHECKED
	state = checked

func _ready() -> void:
	if Engine.is_editor_hint(): return
	Settings.file_loaded.connect(func():
		if id in Settings.data:
			var _c = Settings.data[id]
			_set_checked(Utils.b(_c))
		else:
			Utils.pdebug("Missing setting '" + id
				+ "', hiding it.", "SettingsPane/SCheckbox")
			visible = false)

func _on_check_box_gui_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("left_click"):
		_set_checked()
		Settings.change(id, str(state))
