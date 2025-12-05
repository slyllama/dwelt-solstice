extends CanvasLayer

func _on_toggle_inventory_pressed() -> void:
	$Inventory.visible = !$Inventory.visible

func _on_save_pressed() -> void:
	Save.save_to_file()
