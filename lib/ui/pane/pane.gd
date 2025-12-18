@tool
extends Panel

@export var title_text := "((Title))":
	get: return(title_text)
	set(_val):
		title_text = _val
		$Box/Header/Title.text = title_text
