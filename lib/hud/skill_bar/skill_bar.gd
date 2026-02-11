@tool
extends HBoxContainer

const skill_count := 10

func _ready() -> void:
	for i in skill_count:
		var skill_button = SkillButton.new()
		add_child(skill_button)
		
		# Randomly modulate frames and flip every second frame, for variation
		var rand_mod := randf_range(0.7, 1.0)
		skill_button.frame.modulate = Color(
			rand_mod, rand_mod, rand_mod)
		if i % 2 == 0:
			skill_button.frame.flip_h = true
