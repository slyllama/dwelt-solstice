extends CanvasLayer

func _on_toggle_inventory_pressed() -> void:
	$Inventory.visible = !$Inventory.visible
