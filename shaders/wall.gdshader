shader_type spatial;
uniform sampler2D height_curve;
uniform vec3 color_top:source_color;
uniform vec3 color_bottom:source_color;
varying vec3 world_vertex;
void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
    world_vertex = (INV_VIEW_MATRIX * vec4(VERTEX, 1)).xyz;
	float adjusted = texture(height_curve, vec2(world_vertex.y/2., 0)).r;
	ALBEDO = color_bottom;
	// Called for every pixel the material is visible on.
}

void light() {
	float light_strength = clamp(dot(NORMAL, LIGHT), 0.0, 1.0);
	float adjusted = texture(height_curve, vec2((world_vertex.y+.005)/2.01, 0)).r;
	light_strength = min(1.0-adjusted, light_strength);
    DIFFUSE_LIGHT += light_strength * ATTENUATION * LIGHT_COLOR / PI;
}
