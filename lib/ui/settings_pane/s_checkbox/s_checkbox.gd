@tool
extends HBoxContainer

@export var id := "setting"

@export var title := "((Setting))":
	set(_title):
		title = _title
		$Label.text = title

@export var state := false

func _ready() -> void:
	if Engine.is_editor_hint(): return
	#Settings.file_loaded.connect(func():
		#if id in Settings.data:
			#$Value.selected = options.find(Settings.data[id]))
