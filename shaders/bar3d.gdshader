shader_type spatial;
render_mode unshaded;
uniform sampler2D bar_texture;
uniform float fill:hint_range(0.0, 1.0, 0.01);
uniform vec3 fill_color:source_color;
uniform vec3 unfill_color:source_color;
uniform bool fill_reverse = false;
uniform bool y_billboard = false; // Enables Y-Billboarding when true

void vertex() {
	if (y_billboard == true) {
		MODELVIEW_MATRIX = VIEW_MATRIX * mat4(vec4(normalize(cross(vec3(0.0, 1.0, 0.0), INV_VIEW_MATRIX[2].xyz)), 0.0), vec4(0.0, 1.0, 0.0, 0.0), vec4(normalize(cross(INV_VIEW_MATRIX[0].xyz, vec3(0.0, 1.0, 0.0))), 0.0), MODEL_MATRIX[3]);
	}
	else {
		MODELVIEW_MATRIX = VIEW_MATRIX * mat4(INV_VIEW_MATRIX[0], INV_VIEW_MATRIX[1], INV_VIEW_MATRIX[2], MODEL_MATRIX[3]);
	}
	MODELVIEW_NORMAL_MATRIX = mat3(MODELVIEW_MATRIX);
}

void fragment() {
	vec4 tex = texture(bar_texture, UV);
	float bar_area = step(.1, tex.r);
	float bar_fill = 1.-step(fill, UV.x);
	if(fill_reverse){
		bar_fill = step(1.0-fill, UV.x);;
	}
	bar_fill *= bar_area;
	vec3 color = mix(unfill_color, fill_color, bar_fill);
	color = mix(color, vec3(1), tex.g);
	color = mix(color, vec3(0), tex.b);
	ALBEDO.rgb = color;
	ALPHA = tex.a;
}