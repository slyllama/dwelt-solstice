shader_type sky;

uniform sampler2D gradient_texture: source_color, hint_default_black;

uniform sampler2D stars_texture: source_color, filter_nearest, repeat_enable;
uniform sampler2D stars_gradient_mask_texture: filter_linear;
uniform sampler2D stars_patina_texture: filter_linear, repeat_enable;
uniform float stars_scale = 8.0;

uniform sampler2D nebula_texture: source_color, filter_nearest, repeat_enable;
uniform sampler2D nebula_patina_texture: filter_linear, repeat_enable;
uniform float nebula_scale = 8.0;

void sky() {
	COLOR = texture(gradient_texture, SKY_COORDS).rgb;
	
	// Add stars
	vec3 stars = texture(stars_texture, SKY_COORDS * stars_scale).rgb;
	float stars_patina = texture(stars_patina_texture, SKY_COORDS).r;
	float stars_gradient_mask = texture(stars_gradient_mask_texture, SKY_COORDS).r;
	stars = stars * stars_patina * stars_gradient_mask;
	
	vec3 nebula = texture(nebula_texture, SKY_COORDS * nebula_scale + TIME * vec2(0.0, -0.01)).rgb;
	float nebula_patina = texture(nebula_patina_texture, SKY_COORDS + TIME * 0.01).r;
	nebula = nebula * stars_gradient_mask;
	
	COLOR += stars;
	COLOR = mix(COLOR, nebula, nebula_patina);
}
