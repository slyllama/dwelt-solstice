@tool
extends PanelContainer

@export var id := "setting"

@export var title := "((Setting))":
	set(_title):
		title = _title
		%Title.text = title

@export var options: Array[String] = []:
	set(_options):
		options = _options

var current := 0

func focus() -> void:
	$Box/Previous.grab_focus()

func refresh_setting() -> void:
	if Engine.is_editor_hint(): return
	if id in Settings.data:
		%Value.text = fmt_option(Settings.data[id])
		current = options.find(Settings.data[id])
	else:
		Utils.pdebug("Missing setting '" + id
			+ "', removing it.", "SettingsPane/SMenu")
		queue_free()

func save_setting() -> void:
	if Engine.is_editor_hint(): return
	if Settings.data[id] != options[current]:
		Settings.change(id, options[current])

func fmt_option(option: String) -> String: # visual display
	var _s = option
	_s = _s.replace("_", " ")
	_s = _s.capitalize()
	_s = _s.replace(" fps", "fps")
	return(_s)

func _ready() -> void:
	if Engine.is_editor_hint(): return
	#Settings.file_loaded.connect(refresh_setting)

# These functions don't actually change settings, they just set the current displayed value
# Call save() to apply them
func _on_next_pressed() -> void:
	if current + 1 < options.size(): current += 1
	else: current = 0
	%Value.text = fmt_option(options[current])

func _on_previous_pressed() -> void:
	if current > 0: current -= 1
	else: current = options.size() - 1
	%Value.text = fmt_option(options[current])
