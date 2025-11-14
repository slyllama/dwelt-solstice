extends VisibleOnScreenNotifier3D

@export var spatial_text := "((Text))":
	get: return(spatial_text)
	set(_val):
		spatial_text = _val
		$BG/Root/Label.text = _val

func _process(_delta: float) -> void:
	var _pos:Vector2 = Dwelt.r_camera.unproject_position(global_position)
	$BG/Root.position = _pos

func _on_screen_entered() -> void: if !visible: visible = true

func _on_screen_exited() -> void: if visible: visible = false
