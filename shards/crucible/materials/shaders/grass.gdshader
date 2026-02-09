shader_type spatial;
render_mode specular_disabled;

uniform sampler2D grass_base_texture: filter_nearest, source_color, repeat_enable;
uniform sampler2D grass_blend_texture: filter_nearest, source_color, repeat_enable;
uniform sampler2D grass_mask_texture: filter_nearest, repeat_enable;

instance uniform float grass_base_uv = 1.0;
instance uniform float grass_blend_uv = 1.0;

void fragment() {
	vec3 grass_base = texture(grass_base_texture, UV * grass_base_uv).rgb;
	vec3 grass_blend = texture(grass_blend_texture, UV * grass_blend_uv).rgb;
	float grass_mask = texture(grass_mask_texture, UV).r;
	
	ALBEDO = mix(grass_base, grass_blend, grass_mask);
}
