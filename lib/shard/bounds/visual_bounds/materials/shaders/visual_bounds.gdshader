shader_type spatial;
render_mode unshaded, fog_disabled, ambient_light_disabled, shadows_disabled;
#include "res://generic/materials/shaders/utils.gdshaderinc"

uniform sampler2D bands_texture: source_color, filter_linear_mipmap, repeat_enable;
uniform float bands_uv_scale = 16.0;

void fragment() {
	vec2 _uv = rotate(UV, vec2(0.5), PI / 4.0) * bands_uv_scale;
	vec4 _b = texture(bands_texture, _uv);
	ALBEDO = _b.rgb;
	ALPHA = _b.a * (0.2 + abs(sin(TIME))* 0.3);

	float fade_distance = length(VERTEX);
	const vec3 magic = vec3(0.06711056, 0.00583715, 52.9829189);
	float fade = clamp(smoothstep(6.0, 4.0, fade_distance), 0.0, 1.0);
	if (fade < 0.001 || fade < fract(magic.z * fract(dot(FRAGCOORD.xy, magic.xy)))) {
		discard;
	}
	// Also fade as the camera approaches
	float fade_close = clamp(smoothstep(1.0, 1.5, fade_distance), 0.0, 1.0);
	if (fade_close < 0.001 || fade_close < fract(magic.z * fract(dot(FRAGCOORD.xy, magic.xy)))) {
		discard;
	}
}
