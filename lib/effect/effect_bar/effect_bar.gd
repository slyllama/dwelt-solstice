extends HBoxContainer

var EffectIcon = load("res://lib/effect/effect_icon/effect_icon.tscn")

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
	if !effect_handler: return
	
	# Disconnect the existing signal (for when targets change)
	if effect_handler.effect_added.is_connected(add_icon):
		effect_handler.effect_added.disconnect(add_icon)
	effect_handler.effect_added.connect(add_icon)
	
	for _n in get_children(): _n.queue_free() # clear
	for _n: Effect in effect_handler.get_children():
		add_icon(_n.data)

func _ready() -> void:
	# Clear debugging placeholders
	for _n in get_children():
		_n.queue_free()
