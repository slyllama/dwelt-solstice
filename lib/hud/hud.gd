extends CanvasLayer

func _ready() -> void:
	await get_tree().process_frame
	%EyeAnim.animate()

func _on_toggle_inventory_pressed() -> void:
	if !$Inventory.visible:
		$Inventory.appear()
	else: $Inventory.disappear()

func _process(_delta: float) -> void:
	$Debug.text = str(get_window().get_mouse_position())
