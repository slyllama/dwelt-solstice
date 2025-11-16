extends HBoxContainer

@onready var buttons_array: Array[Node] = get_children()

var hovered_button: TopMenuButton

func _input(_event: InputEvent) -> void:
	if !hovered_button: return
	if Input.is_action_just_pressed("ui_right"):
		var _ind = buttons_array.find(hovered_button)
		if _ind < buttons_array.size() - 1:
			hovered_button.clear_hovered()
			var _b: TopMenuButton = buttons_array[_ind + 1]
			_b.show_hovered()
			hovered_button = _b
	if Input.is_action_just_pressed("ui_left"):
		var _ind = buttons_array.find(hovered_button)
		if _ind > 0:
			hovered_button.clear_hovered()
			var _b: TopMenuButton = buttons_array[_ind - 1]
			_b.show_hovered()
			hovered_button = _b

func clear_hovered() -> void:
	if hovered_button:
		hovered_button.clear_hovered()

func _ready() -> void:
	get_window().focus_exited.connect(clear_hovered)
	
	for _b: TopMenuButton in buttons_array:
		_b.mouse_entered.connect(func():
			clear_hovered()
			_b.show_hovered()
			hovered_button = _b)
		_b.mouse_exited.connect(func():
			var _last_hovered: TopMenuButton = hovered_button
			await get_tree().process_frame
			if hovered_button == _last_hovered:
				clear_hovered()
				hovered_button = null)
