class_name EffectHandler extends Node

signal updated

# Registering an effects makes sure that the handler updates when it is
# freed. It is a separate function so that child effects added in the
# editor can also be registered at runtime.
func register(effect: Effect) -> void:
	effect.tree_exited.connect(func():
		# TODO: effect expired logic
		print("effect handler: " + effect.data.id + " freed")
		updated.emit())

func add(data: EffectData) -> void:
	var _e = Effect.new()
	_e.data = data
	add_child(_e)
	register(_e)
	
	updated.emit()

func _ready() -> void:
	for _e: Effect in get_children():
		register(_e)
	
	await get_tree().process_frame
	updated.emit()

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("debug_key"):
		var _d = EffectData.new()
		_d.id = "one_second_effect"
		_d.indefinite = false
		_d.duration = 1.0
		add(_d)
