@tool
class_name SkillButton extends TextureButton

const SIZE := 72.0
const HOVER_STRENGTH := 2.0 # modulation on hover
const FRAME_TEX = preload("res://lib/hud/skill_button/textures/frame.png")

@onready var frame = TextureRect.new()

func _init() -> void:
	# Set up node
	custom_minimum_size = Vector2(SIZE, SIZE)
	ignore_texture_size = true
	stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_COVERED

# Set up the frame which goes around the skill icon
func render_frame() -> void:
	frame.stretch_mode = TextureRect.STRETCH_SCALE
	frame.set_anchors_preset(Control.PRESET_FULL_RECT)
	frame.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	frame.mouse_filter = Control.MOUSE_FILTER_IGNORE
	frame.texture = FRAME_TEX
	add_child(frame)

func hover() -> void:
	modulate = Color.WHITE * HOVER_STRENGTH

func unhover() -> void:
	modulate = Color.WHITE

func _ready() -> void:
	mouse_entered.connect(hover)
	mouse_exited.connect(unhover)
	
	# TODO: for debugging
	texture_normal = load("res://generic/materials/textures/tile_diff.jpg")
	self_modulate = Color(0.3, 0.3, 0.3)
	
	render_frame()
