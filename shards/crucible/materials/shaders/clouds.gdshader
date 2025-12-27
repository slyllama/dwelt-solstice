shader_type spatial;
render_mode unshaded, cull_front, ambient_light_disabled, shadows_disabled;

uniform sampler2D clouds_texture: filter_linear_mipmap, repeat_enable;
uniform vec3 clouds_color: source_color = vec3(1.0);
uniform float time_scale = 0.002;

void fragment() {
	float _c = texture(clouds_texture, UV + TIME * vec2(0.0, time_scale)).a;
	ALBEDO = clouds_color;
	ALPHA = _c;
}
