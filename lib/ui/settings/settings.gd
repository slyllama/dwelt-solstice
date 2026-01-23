@tool
extends CanvasLayer

func appear() -> void:
	if !Engine.is_editor_hint(): # shield so as not to freeze editor
		get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	var focus_grabbed := false
	# Update the displayed setting on each box before displaying them
	for _n in %SettingsBox.get_children():
		if _n.has_method("refresh_setting"):
			_n.refresh_setting()
			if !focus_grabbed:
				if _n.has_method("focus"):
					_n.focus() # grab focus on first box
					focus_grabbed = true
	visible = true
	$Animations.play("appear")
	Dwelt.screen_fx.appear_smoke(0.15)

func disappear() -> void:
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	$Animations.play("disappear")
	Dwelt.screen_fx.disappear_smoke(0.2)
	await $Animations.animation_finished
	visible = false

func _ready() -> void:
	if Engine.is_editor_hint(): # show for debugging
		$Animations.play("appear")
		return
	visible = false
	get_window().focus_exited.connect(appear)

func _input(_event: InputEvent) -> void:
	# Toggle appearing and disappearing of the pane
	if Input.is_action_just_pressed("ui_cancel"):
		if !visible:
			$Open.play()
			appear()
		else: disappear()

func _process(_delta: float) -> void:
	if visible: %Motes.global_position = $BG/MotesAnchor.global_position

func _on_cancel_pressed() -> void:
	disappear()

func _on_apply_pressed() -> void:
	# Save each setting to file, and apply them
	for _n in %SettingsBox.get_children():
		if _n.has_method("save_setting"):
			_n.save_setting()
	disappear()
