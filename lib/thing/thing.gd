class_name Thing extends Node3D

@export var body: StaticBody3D

@export_category("Data and Properties")
@export var data: ThingData = ThingData.new()
@export var owned_by_player := true

func _get_dist_to_player() -> float:
	var _d := global_position.distance_to(Dwelt.player.global_position)
	_d = snapped(_d, 0.1)
	return(_d)

func _ready() -> void:
	if !body: return
	body.input_event.connect(func(_c, _e, _p, _n, _i):
		if Input.is_action_just_released("left_click"):
			Dwelt.target_thing(self))
