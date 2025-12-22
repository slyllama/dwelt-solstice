class_name DissolveHelper extends Node

@export var dissolve_control: Control

func _set_dissolve(value: float) -> void:
	if dissolve_control:
		if dissolve_control.material:
			dissolve_control.material.set_shader_parameter("value", value)

# Returns 0 if a value wasn't assigned
func _get_dissolve() -> float:
	if dissolve_control:
		if dissolve_control.material:
			return(dissolve_control.material.get_shader_parameter("value"))
		else: return(0.0)
	else: return(0.0)

func appear() -> void:
	if !dissolve_control: return
	dissolve_control.visible = true
	var _d = create_tween()
	_d.tween_method(_set_dissolve, _get_dissolve(), 1.0, 0.25)

func disappear() -> void:
	if !dissolve_control: return
	_set_dissolve(1.0)
	var _d = create_tween()
	_d.tween_method(_set_dissolve, _get_dissolve(), 0.0, 0.25)
	_d.tween_callback(func(): dissolve_control.visible = false)

func _ready() -> void:
	if !dissolve_control:
		Utils.pdebug("Warning: DissolveHelper with parent '"
			+ str(get_parent().name) + "' is not linked to a Control.", "DissolveHeler")
