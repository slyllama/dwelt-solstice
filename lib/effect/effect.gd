class_name Effect extends Node

@export var data: EffectData:
	set(_data):
		data = _data
		setup()

var timer: Timer
var params: EffectParameter

func expire() -> void:
	data.expired.emit()
	queue_free()

func replenish() -> void:
	timer.start(data.duration)

func setup() -> void:
	params = EffectLibrary.get_param(data.id)
	if !params.indefinite: # set up timer if the effect is not indefinite
		timer = Timer.new() # could happen before @onready
		timer.wait_time = data.duration
		timer.one_shot = true
		timer.timeout.connect(expire)
		
		# Need to wait till ready, because data can be assigned before
		# the node is added to the scene
		await ready
		add_child(timer)
		timer.start()

func _process(_delta: float) -> void:
	if !data: return
	if params:
		if !params.indefinite:
			data.remaining_time = snapped(timer.time_left, 0.1)
