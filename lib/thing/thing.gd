class_name Thing extends Node3D

const SelIndicator = preload("res://lib/thing/sel_indicator/sel_indicator.tscn")

@export var body: StaticBody3D
@export var mesh: Node3D
@export_category("Data and Properties")
@export var data: ThingData = ThingData.new()
@export var owned_by_player := true

@onready var mat_handler := ThingMatHandler.new()
@onready var sel_indicator: Node3D = SelIndicator.instantiate()

func _get_dist_to_player() -> float:
	var _d := global_position.distance_to(Dwelt.player.global_position)
	_d = snapped(_d, 0.1)
	return(_d)

func hover() -> void:
	mat_handler.set_highlight()

func unhover() -> void:
	# Can only be unhovered if not targeted
	if Dwelt.targeted_thing != self:
		mat_handler.set_highlight(false)

func _ready() -> void:
	# Setup helper children
	mat_handler.mesh = mesh
	sel_indicator.visible = false
	sel_indicator.position.y = 2.0
	
	# Add helper children
	add_child(mat_handler)
	add_child(sel_indicator)
	
	Dwelt.thing_targeted.connect(func():
		if Dwelt.targeted_thing != self:
			sel_indicator.visible = false
			mat_handler.set_highlight(false))
	
	# Handle input events
	if !body: return
	
	body.input_event.connect(func(_c, _e, _p, _n, _i):
		if Input.is_action_just_released("left_click"):
			sel_indicator.visible = true
			Dwelt.target_thing(self))
