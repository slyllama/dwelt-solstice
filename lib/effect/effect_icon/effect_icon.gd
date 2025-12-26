class_name EffectIconScript extends TextureRect

@export var data: EffectData:
	set(_data):
		data = _data
		connect_data()

var params: EffectParameter

# Once connected, EffectData can free this icon once expired
func connect_data() -> void:
	data.expired.connect(queue_free)
	params = EffectLibrary.get_param(data.id)

func _process(_delta: float) -> void:
	if data:
		if !params.indefinite:
			$RemainingTime.text = str(data.remaining_time)
