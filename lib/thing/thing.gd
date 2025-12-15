class_name Thing extends Node3D

@export var body: StaticBody3D

@export_category("Data and Properties")
@export var data: ThingData = ThingData.new()
@export var owned_by_player := true

func _ready() -> void:
	if !body:
		print("no body :(")
		return
	body.input_event.connect(func(_c, _e, _p, _n, _i):
		if Input.is_action_just_pressed("left_click"):
			Dwelt.target_thing(self))
