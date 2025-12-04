shader_type spatial;
render_mode specular_disabled;

uniform sampler2D albedo_texture: source_color, filter_linear_mipmap;
uniform sampler2D normal_texture: hint_normal;
uniform float uv_scale = 1.0;
uniform float normal_strength = 1.0;
uniform vec3 albedo_color: source_color = vec3(1.0);

void fragment() {
	ALBEDO = texture(albedo_texture, UV * uv_scale).rgb * albedo_color;
	NORMAL_MAP = texture(normal_texture, UV * uv_scale).rgb;
	NORMAL_MAP_DEPTH = normal_strength;
}
