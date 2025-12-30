extends PanelContainer

@export var text := "((Tooltip))":
	set(_text):
		text = _text
		$Label.text = _text
