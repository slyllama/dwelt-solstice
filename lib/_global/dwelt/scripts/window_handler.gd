extends Node

const SCREEN_POS_OFFSET := Vector2i(30, 60)

@onready var screen_origin := DisplayServer.screen_get_position()

func _is_retina() -> bool:
	if DisplayServer.screen_get_size().x > 2000:
		return(true)
	else: return(false)

func _ready() -> void:
	if _is_retina():
		get_window().content_scale_factor = 2.0
	
	if Engine.is_embedded_in_editor(): return
	
	if _is_retina(): get_window().size *= 2
	get_window().position = screen_origin + SCREEN_POS_OFFSET
