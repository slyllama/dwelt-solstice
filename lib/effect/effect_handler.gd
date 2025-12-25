class_name EffectHandler extends Node

signal updated

func add(id: String) -> void:
	var _e = Effect.new()
	var _ed = EffectData.new()
	_ed.effect_id = id
	_e.effect_data = _ed
	add_child(_e)
	updated.emit()

func _ready() -> void:
	await get_tree().process_frame
	updated.emit()

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("debug_key"):
		add("test_effect")
