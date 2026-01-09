shader_type spatial;
render_mode specular_disabled;

// Grasses
uniform sampler2D grass_texture: filter_linear_mipmap, repeat_enable, source_color;
uniform vec3 grass_albedo: source_color = vec3(0.5);
uniform float grass_uv_scale = 16.0;
uniform sampler2D grass_alt_texture: filter_linear_mipmap, repeat_enable, source_color;
uniform vec3 grass_alt_albedo: source_color = vec3(0.5);
uniform float grass_alt_uv_scale = 16.0;

// Rocks - use red channel
uniform sampler2D rock_texture: filter_linear_mipmap, repeat_enable, source_color;
uniform vec3 rock_albedo: source_color = vec3(0.5);
uniform float rock_uv_scale = 16.0;

// Highlights - use blue channel
uniform float highlight_strength = 1.75;

// Masks
uniform sampler2D grass_mask_texture: filter_linear_mipmap, hint_default_black;
uniform sampler2D landscape_mask_texture: filter_linear_mipmap, hint_default_black;

void fragment() {
	// Set up masks
	vec3 _lm = texture(landscape_mask_texture, UV).rgb; // includes all 3 channels of data
	float _gm = texture(grass_mask_texture, UV).r;

	// Grass bases
	vec3 _g = texture(grass_texture, UV * grass_uv_scale).rgb;
	vec3 _ga = texture(grass_alt_texture, UV * grass_alt_uv_scale).rgb;
	_g *= grass_albedo;
	_ga *= grass_alt_albedo;
	ALBEDO = mix(_g, _ga, _gm);

	// Rocks
	vec3 _r = texture(rock_texture, UV * rock_uv_scale).rgb;
	_r *= rock_albedo;
	ALBEDO = mix(ALBEDO, _r, _lm.r);

	// Post-processing
	ALBEDO *= (1.0 + _lm.b * highlight_strength);
}
