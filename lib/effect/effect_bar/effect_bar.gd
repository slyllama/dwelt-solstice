extends HBoxContainer

const EffectIcon = preload("res://lib/effect/effect_icon/effect_icon.tscn")

@export var effect_handler: EffectHandler:
	set(_effect_handler):
		effect_handler = _effect_handler
		connect_handler()

func add_icon(data: EffectData) -> void:
	var _e: EffectIconScript = EffectIcon.instantiate()
	add_child(_e)
	_e.data = data

# Once connected, an EffectHandler can spawn effect icons here
func connect_handler() -> void:
	for _n in get_children():
		_n.queue_free() # clear
	if !effect_handler: return
	for _n: Effect in effect_handler.get_children():
		add_icon(_n.data)
	if !effect_handler.effect_added.get_connections():
		effect_handler.effect_added.connect(add_icon)

func _ready() -> void:
	for _n in get_children():
		_n.queue_free() # clear debugging placeholders
