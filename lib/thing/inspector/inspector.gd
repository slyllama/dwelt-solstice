extends TextureRect

func _set_dissolve(value: float) -> void:
	material.set_shader_parameter("value", value)

func appear() -> void:
	update() # render data
	
	# Visually appear
	_set_dissolve(0.0)
	visible = true
	var _d = create_tween()
	_d.tween_method(_set_dissolve, 0.0, 1.0, 0.17)

# Render the correct Thing data for the targeted Thing
func update() -> void:
	var _t := Dwelt.targeted_thing
	$Title.text = _t.data.thing_name

func _init() -> void:
	visible = false
	
	Dwelt.thing_targeted.connect(func():
		appear())
