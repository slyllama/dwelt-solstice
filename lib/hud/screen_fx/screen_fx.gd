class_name ScreenFX extends CanvasLayer

func appear_smoke(speed := 1.3) -> void:
	$Smoke.appear(speed)

func disappear_smoke(speed := 1.3) -> void:
	$Smoke.disappear(speed)

func _ready() -> void:
	Dwelt.screen_fx = self # create a global reference
