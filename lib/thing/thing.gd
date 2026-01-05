class_name Thing extends Node3D

const SelIndicator = preload("res://lib/thing/sel_indicator/sel_indicator.tscn")

@export var body: CollisionObject3D
@export var mesh: Node3D
@export var selector_point: Marker3D

@export_category("Data and Properties")
@export var data: ThingData = ThingData.new()
@export var owned_by_player := true

@export_category("Rendering")
@export var distance_fade := false:
	set(_distance_fade):
		distance_fade = _distance_fade
		_update_distance_fade()
@export var distance_fade_amount := 30.0:
	set(_distance_fade_amount):
		distance_fade_amount = _distance_fade_amount
		_update_distance_fade()

@onready var mat_handler := ThingMatHandler.new()
@onready var sel_indicator: Node3D = SelIndicator.instantiate()
@onready var effect_handler := EffectHandler.new()

func _get_dist_to_player() -> float:
	var _d := global_position.distance_to(Dwelt.player.global_position)
	_d = snapped(_d, 0.1)
	return(_d)

func _update_distance_fade() -> void:
	if !mat_handler: return
	mat_handler.set_distance_fade(distance_fade)
	mat_handler.set_distance_fade_amount(distance_fade_amount)

func hover() -> void:
	mat_handler.set_highlight()

func unhover() -> void:
	# Can only be unhovered if not targeted
	mat_handler.set_highlight(false)

func _ready() -> void:
	# Setup helper children
	mat_handler.mesh = mesh
	sel_indicator.visible = false
	if selector_point:
		sel_indicator.position = selector_point.position
	else: sel_indicator.position.y = 2.0
	
	# Add helper children
	add_child(mat_handler)
	add_child(sel_indicator)
	add_child(effect_handler)
	
	_update_distance_fade()
	
	Dwelt.thing_targeted.connect(func():
		if Dwelt.targeted_thing != self:
			sel_indicator.visible = false)
	
	# TODO: test permanent effects
	var _t = EffectData.new()
	_t.id = "test_effect"
	effect_handler.add(_t)
	
	# Handle input events
	if !body: return
	body.input_event.connect(func(_c, _e, _p, _n, _i):
		if Input.is_action_just_released("left_click"):
			if get_window().gui_get_hovered_control(): return
			sel_indicator.visible = true
			Dwelt.target_thing(self))

func _input(_event: InputEvent) -> void:
	if !Dwelt.targeted_thing == self: return
	# TODO: test temporary effects
	if Input.is_action_just_pressed("debug_key"):
		var _d = EffectData.new()
		_d.id = "lethargy"
		_d.duration = 5.0
		effect_handler.add(_d)
