shader_type spatial;
render_mode unshaded;

uniform vec4 albedo : source_color;
uniform sampler2D texture_albedo : source_color,filter_linear_mipmap,repeat_enable;
uniform vec2 Direction = vec2(1.0,0.0);
uniform float Speed = 0.02;
uniform float tile_size = 1;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 base_uv = vec2 (UV.x * tile_size,UV.y);
	vec4 albedo_tex = texture(texture_albedo,base_uv + (Direction * TIME * Speed));
	ALBEDO = (albedo.rgb * albedo_tex.rgb);
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
