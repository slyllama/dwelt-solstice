shader_type spatial;
render_mode specular_disabled;

uniform sampler2D albedo_texture: source_color, filter_linear_mipmap;
uniform sampler2D normal_texture: hint_normal;
uniform float uv_scale = 1.0;
uniform float normal_strength = 1.0;
uniform vec3 albedo_color: source_color = vec3(1.0);
instance uniform bool highlighted = false;

// Fade handling
instance uniform bool distance_fade = false;
instance uniform float distance_fade_amount = 10.0;

void fragment() {
	ALBEDO = texture(albedo_texture, UV * uv_scale).rgb * albedo_color;
	NORMAL_MAP = texture(normal_texture, UV * uv_scale).rgb;
	NORMAL_MAP_DEPTH = normal_strength;
	
	// Highlighting
	if (highlighted == true) {
		ALBEDO *= 2.0;
		ALBEDO = clamp(ALBEDO, vec3(0.0), vec3(1.0));
	}
	
	bool is_shadow_pass = (PROJECTION_MATRIX[2][3] == 0.0);
	if(!is_shadow_pass) {
		float fade_distance = length(VERTEX);
		const vec3 magic = vec3(0.06711056, 0.00583715, 52.9829189);
		
		float dfmn = distance_fade_amount;
		float dfmx = distance_fade_amount - 1.0;
		if(is_shadow_pass) { dfmn= 0.0; dfmx= 0.1; }
		
		float _far = clamp(smoothstep(dfmn, dfmx, fade_distance), 0.0, 1.0);
		if (_far < 0.001 || _far < fract(magic.z * fract(dot(FRAGCOORD.xy, magic.xy)))) {
			if (distance_fade == true) { discard; }
		}
		
		float _near = clamp(smoothstep(1.0, 1.5, fade_distance), 0.0, 1.0);
		if (_near < 0.001 || _near < fract(magic.z * fract(dot(FRAGCOORD.xy, magic.xy)))) {
			discard;
		}
	}
}
