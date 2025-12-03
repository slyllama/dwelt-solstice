shader_type sky;

uniform sampler2D color_gradient: source_color, filter_linear;

// Patina
uniform sampler2D patina: source_color, hint_default_black, filter_linear;
uniform float patina_size = 1.0;
uniform float patina_strength = 1.0;

// Stars
uniform sampler2D stars: source_color, filter_linear, repeat_enable;
uniform sampler2D stars_gradient_mask: source_color, filter_linear;
uniform float stars_size = 1.0;
uniform float stars_strength = 1.0;

void sky() {
	COLOR = texture(color_gradient, SKY_COORDS).rgb;

	// Patina
	vec3 _patina = texture(patina, SKY_COORDS * patina_size).rgb;
	_patina = (1.0 + _patina) * patina_strength;
	COLOR *= _patina;

	// Stars
	vec3 _stars = texture(stars, SKY_COORDS * stars_size).rgb;
	float _stars_mask = clamp(texture(patina, SKY_COORDS * -1.0).r, 0.18, 1.0);
	_stars_mask = pow(_stars_mask, 0.75); // soften
	_stars = _stars * stars_strength * _stars_mask;
	_stars *= texture(stars_gradient_mask, SKY_COORDS).r;
	COLOR += _stars;
}
