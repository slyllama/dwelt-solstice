extends CanvasLayer

func _on_toggle_inventory_pressed() -> void:
	if !$Inventory.visible:
		$Inventory.appear()
	else: $Inventory.disappear()

func _on_save_pressed() -> void:
	Save.save_to_file()
