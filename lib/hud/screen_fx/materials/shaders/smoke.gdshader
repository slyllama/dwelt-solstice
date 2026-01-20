shader_type canvas_item;
#include "res://generic/materials/shaders/utils.gdshaderinc"

uniform sampler2D smoke_texture: filter_linear, repeat_enable;
uniform sampler2D wobble_texture: filter_linear, repeat_enable;

uniform float state: hint_range(0.0, 1.0) = 0.0;
uniform float feather: hint_range(0.0, 0.5) = 0.2;
uniform float smoke_uv_scale = 4.0;

void fragment() {
	float wobble = texture(wobble_texture, UV + TIME * 0.1).r;
	float smoke = texture(smoke_texture, UV * smoke_uv_scale + wobble * 0.1).r;
	float mask = circle(UV, state, feather);
	COLOR.a = smoke * mask;
}
