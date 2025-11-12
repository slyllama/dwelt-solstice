float circle(vec2 p, float r, float f) {
	return(smoothstep(r, r + f, length(p - vec2(0.5))));
}

vec3 color_dodge(vec3 base, vec3 blend){
	return(base / (1.0 - blend));
}

