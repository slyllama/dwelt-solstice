class_name TopMenuButton extends TextureButton

var _target_alpha := 0.5

func show_hovered() -> void:
	_target_alpha = 1.0
	$Anim.play("hover")

func clear_hovered() -> void:
	_target_alpha = 0.5
	$Anim.play_backwards("hover")

func _ready() -> void:
	modulate.a = _target_alpha

func _process(_delta: float) -> void:
	modulate.a = lerp(modulate.a,
		_target_alpha, Utils.crit_lerp(15.0))
