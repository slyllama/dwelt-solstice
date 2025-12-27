class_name EffectIconScript extends TextureRect

enum BlinkState { SOLID, BLINK_SLOW, BLINK_FAST }

const SLOW_BLINK_TIME = 3.0
const FAST_BLINK_TIME = 1.0

@export var data: EffectData:
	set(_data):
		data = _data
		connect_data()

var params: EffectParameter
var blink_state = BlinkState.SOLID

# Once connected, EffectData can free this icon once expired
func connect_data() -> void:
	data.expired.connect(queue_free)
	params = EffectLibrary.get_param(data.id)
	texture = params.effect_icon

func _process(_delta: float) -> void:
	if data:
		if !params.indefinite:
			if data.remaining_time >= SLOW_BLINK_TIME:
				if blink_state != BlinkState.SOLID:
					blink_state = BlinkState.SOLID
					%Blink.play("RESET")
					return
			elif data.remaining_time < SLOW_BLINK_TIME and data.remaining_time >= FAST_BLINK_TIME:
				if blink_state == BlinkState.SOLID:
					blink_state = BlinkState.BLINK_SLOW
					%Blink.play("blink_slow")
					return
			elif data.remaining_time < FAST_BLINK_TIME:
				if blink_state == BlinkState.BLINK_SLOW:
					blink_state = BlinkState.BLINK_FAST
					%Blink.play("blink_fast")
					return
