shader_type canvas_item;
#include "res://generic/materials/shaders/utils.gdshaderinc"

uniform sampler2D hologram_mask_texture: source_color, filter_linear, repeat_enable;
uniform float hologram_uv_scale = 1.0;
uniform float hologram_strength = 0.1;
uniform float hologram_exponent = 1.0;
uniform float hologram_speed = 0.5;

void fragment() {
	vec2 screen_uv = SCREEN_UV + circle(UV, 0.2, 0.3) * 0.1;
	
	vec2 uv = screen_uv * hologram_uv_scale + TIME * vec2(0.0, hologram_speed);
	float hologram = texture(hologram_mask_texture, uv).r * hologram_strength;
	COLOR.a = pow(hologram, hologram_exponent);
}
