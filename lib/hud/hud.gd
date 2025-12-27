extends CanvasLayer

func play_title_card(shard_name: String) -> void:
	%TitleCard.shard_name = shard_name
	%TitleCard.play()

func _ready() -> void:
	await get_tree().process_frame
	# Need to wait a frame for the Dwelt.player reference to be applied
	# TODO: debug for viewing player effects
	%EffectBar.effect_handler = Dwelt.player.effect_handler
	Dwelt.player.effect_handler.updated.connect(func():
		var _text := ""
		for _e: Effect in Dwelt.player.effect_handler.get_children():
			if _e.data:
				var _params: EffectParameter = EffectLibrary.get_param(_e.data.id)
				_text += str(_e.data.id)
				if !_params.indefinite:
					_text += " (" + str(_e.data.duration) + "s)"
				_text += "\n"
		$PlayerEffects.text = _text)
	%EyeAnim.animate()

func _on_toggle_inventory_pressed() -> void:
	if !$Inventory.visible:
		$Inventory.appear()
	else: $Inventory.disappear()

func _on_settings_pressed() -> void:
	if !$SettingsPane.visible:
		$SettingsPane.appear()
	else: $SettingsPane.disappear()
