@tool
extends Panel

@export var title_text := "((Title))":
	get: return(title_text)
	set(_val):
		title_text = _val

@export var start_hidden := false

func appear() -> void:
	$Open.play()
	$DissolveHelper.appear()

func disappear() -> void:
	$DissolveHelper.disappear()

func _ready() -> void:
	if Engine.is_editor_hint(): return
	if start_hidden:
		visible = false
		$DissolveHelper.disappear()

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		if !visible:
			appear()
		else:
			disappear()

func _on_close_pressed() -> void:
	$DissolveHelper.disappear()
