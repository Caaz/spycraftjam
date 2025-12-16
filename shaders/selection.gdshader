shader_type spatial;
render_mode cull_disabled, unshaded;
uniform vec3 color:source_color;
uniform float height = 2.;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
    vec3 world_vertex = (INV_VIEW_MATRIX * vec4(VERTEX, 1)).xyz;
	// Called for every pixel the material is visible on.
	ALBEDO = color;
	ALPHA = mix(1, 0, world_vertex.y/height);
	//if (FRONT_FACING) {
		//ALPHA /= 2.;
	//}
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
