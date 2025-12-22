extends CanvasLayer

func play_title_card(shard_name: String) -> void:
	%TitleCard.shard_name = shard_name
	%TitleCard.play()

func _ready() -> void:
	await get_tree().process_frame
	%EyeAnim.animate()

func _on_toggle_inventory_pressed() -> void:
	if !$Inventory.visible:
		$Inventory.appear()
	else: $Inventory.disappear()

func _process(_delta: float) -> void:
	$Debug.text = str(get_window().get_mouse_position())

func _on_settings_pressed() -> void:
	if !$SettingsPane.visible:
		$SettingsPane.appear()
	else: $SettingsPane.disappear()
