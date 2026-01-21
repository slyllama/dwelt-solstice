@tool
extends CanvasLayer

func appear() -> void:
	var focus_grabbed := false
	# Update the displayed setting on each box before displaying them
	# Grab focus on the first one
	for _n in %SettingsBox.get_children():
		if _n.has_method("refresh_setting"):
			_n.refresh_setting()
			if !focus_grabbed:
				if _n.has_method("focus"):
					_n.focus()
					focus_grabbed = true
	visible = true
	$Animations.play("appear")

func disappear() -> void:
	$Animations.play("disappear")
	await $Animations.animation_finished
	visible = false

func _ready() -> void:
	if Engine.is_editor_hint(): # show for debugging
		$Animations.play("appear")
	else: visible = false

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		if !visible: appear()
		else: disappear()

func _on_cancel_pressed() -> void:
	disappear()

func _on_apply_pressed() -> void:
	for _n in %SettingsBox.get_children():
		if _n.has_method("save_setting"):
			_n.save_setting()
			await get_tree().process_frame
	disappear()
