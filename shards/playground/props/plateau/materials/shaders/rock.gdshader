shader_type spatial;

uniform sampler2D rock_mask_texture: source_color, filter_linear_mipmap, repeat_enable;

uniform sampler2D grass_texture: source_color, filter_linear_mipmap, repeat_enable;
uniform sampler2D grass_normal_texture: hint_normal, filter_linear_mipmap, repeat_enable;
uniform vec3 grass_albedo: source_color = vec3(1.0);
uniform float grass_uv_scale = 7.0;
uniform float grass_normal_map_depth: hint_range(0.0, 1.0) = 1.0;

uniform sampler2D rock_texture: source_color, filter_linear_mipmap, repeat_enable;
uniform sampler2D rock_normal_texture: hint_normal, filter_linear_mipmap, repeat_enable;
uniform vec3 rock_albedo: source_color = vec3(1.0);
uniform float rock_uv_scale = 7.0;

uniform sampler2D dirt_texture: source_color, filter_linear_mipmap, repeat_enable;
uniform vec3 dirt_albedo: source_color = vec3(1.0);
uniform float dirt_uv_scale = 7.0;

void fragment() {
	vec3 _m = texture(rock_mask_texture, UV).rgb;
	vec3 _g = texture(grass_texture, UV * grass_uv_scale).rgb;
	vec3 _gn = texture(grass_normal_texture, UV * grass_uv_scale).rgb;
	vec3 _r = texture(rock_texture, UV * rock_uv_scale).rgb;
	vec3 _rn = texture(rock_normal_texture, UV * rock_uv_scale).rgb;
	vec3 _d = texture(dirt_texture, UV * dirt_uv_scale).rgb;
	
	ALBEDO = mix(_g * grass_albedo, _r * rock_albedo, _m.r);
	ALBEDO = mix(ALBEDO, _d * dirt_albedo, _m.g);
	
	NORMAL_MAP = mix(_gn, _rn, _m.r);
	NORMAL_MAP_DEPTH = grass_normal_map_depth;
	SPECULAR = 0.0;
}
