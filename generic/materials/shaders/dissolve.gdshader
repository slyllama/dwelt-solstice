shader_type canvas_item;

uniform sampler2D dissolve_texture: source_color, filter_linear_mipmap;
uniform float value: hint_range(0.0, 1.0);

void fragment(){
	vec4 _d = texture(dissolve_texture, UV * 0.5);
	float _v = 1.0 - pow(1.0 - value, 7.0);
	COLOR.a = pow(_d.r, (1.0 - _v) * 30.0) * COLOR.a;
	if (value == 0.0) { discard; }
}
