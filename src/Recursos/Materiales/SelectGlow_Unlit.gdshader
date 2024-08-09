shader_type spatial;
render_mode unshaded;
render_mode cull_disabled ;

uniform vec4 albedo : source_color;
uniform sampler2D texture_albedo : source_color,filter_linear_mipmap,repeat_enable;
uniform sampler2D mask : source_color,filter_linear_mipmap,repeat_enable;
uniform vec2 Direction = vec2(0.0,1.0);
uniform float Speed = 0.02;
uniform float tile_size = 1;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 base_uv = vec2 (UV.x * tile_size,UV.y);
	vec4 albedo_tex = texture(texture_albedo,base_uv + (Direction * TIME * Speed));
	vec4 mask_tex = texture(mask,base_uv);
	ALBEDO = (albedo.rgb * (albedo_tex.rgb + albedo.rgb));	
	ALPHA = (mask_tex.r);	
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
