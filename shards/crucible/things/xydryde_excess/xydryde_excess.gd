extends Thing

var player_in_spill := false

func inflict_lethargy() -> void:
	var _lethargy = EffectData.new()
	_lethargy.id = "lethargy"
	_lethargy.duration = 3.0
	Dwelt.player.effect_handler.add(_lethargy)

func _ready() -> void:
	# TODO: built-in debug floor freeing
	$DebugFloor.queue_free()

func _on_body_body_entered(_body: Node3D) -> void:
	if _body is DweltPlayer:
		player_in_spill = true
		inflict_lethargy()
		$LethargyTimer.start()

func _on_body_body_exited(_body: Node3D) -> void:
	if _body is DweltPlayer:
		player_in_spill = false
		$LethargyTimer.stop()

func _on_lethargy_timer_timeout() -> void:
	if player_in_spill:
		inflict_lethargy()
