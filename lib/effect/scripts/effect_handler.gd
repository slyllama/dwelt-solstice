class_name EffectHandler extends Node

signal updated
signal effect_added(data: EffectData)
signal effect_expired(data: EffectData)

# If an effect of a certain ID is in the effects list (children of this node),
# return that effect; if not, return null
func has_effect(id: String) -> Variant:
	for _e: Effect in get_children():
		if _e.data.id == id:
			return(_e)
	return(null)

# Registering an effects makes sure that the handler updates when it is
# freed. It is a separate function so that child effects added in the
# editor can also be registered at runtime.
func register(effect: Effect) -> void:
	effect_added.emit(effect.data)
	effect.tree_exited.connect(func():
		effect_expired.emit(effect.data)
		updated.emit())

func add(data: EffectData) -> void:
	if has_effect(data.id):
		var _existing_effect: Effect = has_effect(data.id)
		var _params: EffectParameter = EffectLibrary.get_param(data.id)
		if _params.duration_replenishes:
			_existing_effect.replenish()
	else:
		# Effect doesn't exist, add it as usual
		var _e = Effect.new()
		_e.data = data
		add_child(_e)
		register(_e)
		updated.emit()

func _ready() -> void:
	await get_tree().process_frame
	for _e: Effect in get_children():
		register(_e)
	updated.emit()
