@tool
extends HBoxContainer

@export var id := "setting"

@export var title := "((Setting))":
	set(_title):
		title = _title
		$Label.text = title

@export var options: Array[String] = []:
	set(_options):
		options = _options
		$Value.remove_item(0) # clear
		for _o in options:
			$Value.add_item(fmt_option(_o))

func fmt_option(option: String) -> String:
	var _s = option
	_s = _s.replace("_", " ")
	_s = _s.capitalize()
	return(_s)

func _ready() -> void:
	if Engine.is_editor_hint(): return
	Settings.file_loaded.connect(func():
		if id in Settings.data:
			$Value.selected = options.find(Settings.data[id])
		else:
			Utils.pdebug("Missing setting '" + id
				+ "', hiding it.", "SettingsPane/SMenu")
			visible = false)

func _on_value_item_selected(index: int) -> void:
	Settings.change(id, options[index])
