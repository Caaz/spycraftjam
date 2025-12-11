shader_type canvas_item;
uniform vec4 color_a:source_color;
uniform vec4 color_b:source_color;
uniform float speed = .1;
void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	COLOR = mix(color_a, color_b, abs(sin((COLOR.r+TIME*speed) * 10.)));
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
