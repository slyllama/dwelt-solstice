shader_type canvas_item;

uniform sampler2D gradient_mask: hint_default_white;
uniform float alpha: hint_range(0.0, 1.0) = 1.0;

void fragment() {
	COLOR.a *= texture(gradient_mask, UV).r;
	COLOR.a *= alpha;
}
