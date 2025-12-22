extends TextureRect

const TIME_IN = 1.25
var gradient_texture: Gradient

@export var shard_name := "((Shard Name))":
	get: return(shard_name)
	set(_shard_name):
		shard_name = _shard_name
		$Label.text = shard_name.capitalize()

func _set_a(val: float) -> void:
	material.set_shader_parameter("alpha", val)
	$Label.self_modulate.a = val
func _set_o0(val: float) -> void: gradient_texture.offsets[0] = val
func _set_o1(val: float) -> void: gradient_texture.offsets[1] = val
func _set_o2(val: float) -> void: gradient_texture.offsets[2] = val
func _set_o3(val: float) -> void: gradient_texture.offsets[3] = val

func play() -> void:
	var _a1 = create_tween()
	_a1.tween_method(_set_a, 0.0, 1.0, 0.1)
	await _a1.finished
	
	var _o0 = create_tween().set_parallel()
	_o0.tween_method(_set_o0, 0.4, 0.01, TIME_IN * 0.75).set_ease(
		Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)
	var _o1 = create_tween().set_parallel()
	_o1.tween_method(_set_o1, 0.45, 0.01, TIME_IN).set_ease(
		Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)
	var _o2 = create_tween().set_parallel()
	_o2.tween_method(_set_o2, 0.55, 0.99, TIME_IN).set_ease(
		Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)
	var _o3 = create_tween().set_parallel()
	_o3.tween_method(_set_o3, 0.6, 0.99, TIME_IN * 0.75).set_ease(
		Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)
	
	await _o3.finished
	await get_tree().create_timer(0.5).timeout
	var _a2 = create_tween()
	_a2.tween_method(_set_a, 1.0, 0.0, 2.0)

func _ready() -> void:
	var _g: GradientTexture2D = material.get_shader_parameter("gradient_mask");
	gradient_texture = _g.gradient
	_set_a(0.0)
	$Label.self_modulate.a = 0.0
