shader_type canvas_item;
uniform float fill:hint_range(0.0, 1.0, 0.01);
uniform vec3 fill_color:source_color;
uniform vec3 unfill_color:source_color;
uniform bool fill_reverse = false;


void fragment() {
	float bar_area = step(.1, COLOR.r);
	float bar_fill = 1.-step(fill, UV.x);
	if(fill_reverse){
		bar_fill = step(1.0-fill, UV.x);;
	}
	bar_fill *= bar_area;
	vec3 color = mix(unfill_color, fill_color, bar_fill);
	color = mix(color, vec3(1), COLOR.g);
	color = mix(color, vec3(0), COLOR.b);
	COLOR.rgb = color;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
