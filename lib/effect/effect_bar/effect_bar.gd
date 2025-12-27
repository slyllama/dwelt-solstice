extends HBoxContainer

const EffectIcon = preload("res://lib/effect/effect_icon/effect_icon.tscn")

@export var effect_handler: EffectHandler:
	set(_effect_handler):
		effect_handler = _effect_handler
		connect_handler()

# Once connected, an EffectHandler can spawn effect icons here
func connect_handler() -> void:
	for _n in get_children():
		queue_free() # clear
	if !effect_handler: return
	effect_handler.effect_added.connect(func(data: EffectData):
		var _e: EffectIconScript = EffectIcon.instantiate()
		add_child(_e)
		_e.data = data)
