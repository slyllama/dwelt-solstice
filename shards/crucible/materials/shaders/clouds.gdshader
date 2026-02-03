shader_type spatial;
render_mode unshaded, cull_front, ambient_light_disabled, shadows_disabled, fog_disabled;

uniform sampler2D clouds_texture: filter_linear_mipmap, repeat_enable;
uniform vec3 clouds_color: source_color = vec3(1.0);
uniform float time_scale = 0.002;

void fragment() {
	float _c = texture(clouds_texture, UV + TIME * vec2(0.0, time_scale)).a;
	ALBEDO = clouds_color;
	ALPHA = _c;
	
	float fade_distance = length(VERTEX);
	const vec3 magic = vec3(0.06711056, 0.00583715, 52.9829189);
	float fade = clamp(smoothstep(40.0, 29.0, fade_distance), 0.0, 1.0);
	if (fade < 0.001 || fade < fract(magic.z * fract(dot(FRAGCOORD.xy, magic.xy)))) {
		discard;
	}
}
