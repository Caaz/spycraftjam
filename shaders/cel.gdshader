shader_type spatial;
uniform vec3 albedo:source_color;
uniform float light_sharpness:hint_range(0,.5);
uniform int light_steps = 1;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	ALBEDO = albedo;
}

float stepped(int steps_int, float value) {
	float steps = float(steps_int);
	float high = ceil(value*steps);
	float low = floor(value*steps);
	float diff = high-low;
	float offset = diff * light_sharpness;
	
	float stepped = smoothstep(low+offset, high-offset, value*steps);
	
	return mix((floor(value*steps)+stepped)/steps, value, 1.- light_sharpness * 2.);
}

void light() {
	float light_strength = clamp(dot(NORMAL, LIGHT), 0.0, 1.0);
	light_strength = stepped(light_steps, light_strength);
    DIFFUSE_LIGHT += light_strength * ATTENUATION * LIGHT_COLOR / PI;
}
