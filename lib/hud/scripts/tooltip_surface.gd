extends Control

@export var tooltip: PanelContainer

func _ready() -> void:
	Dwelt.effect_icon_hovered.connect(func(data: EffectData):
		print(data)
		visible = true)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		tooltip.position = get_window().get_mouse_position() + Vector2(20.0, 20.0)

func _process(_delta: float) -> void:
	if visible:
		if !get_window().gui_get_hovered_control():
			visible = false
