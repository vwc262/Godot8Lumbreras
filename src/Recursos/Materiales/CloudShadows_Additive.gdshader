shader_type spatial;

render_mode unshaded;
uniform vec4 albedo : source_color;
uniform sampler2D texture_clouds : source_color,filter_linear_mipmap,repeat_enable;
uniform float tile_size = 1;
uniform sampler2D texture_heightmap : hint_default_black,filter_linear_mipmap,repeat_enable;
uniform float heightmap_scale;
uniform vec2 heightmap_flip;
uniform vec3 uv1_scale;
uniform vec3 uv1_offset;
uniform vec2 Direction = vec2(1.0,0.0);
uniform float Speed = 0.02;

void vertex() {
	UV=UV*uv1_scale.xy+uv1_offset.xy;
}


void fragment() {

	vec2 base_uv = UV;
	{
		vec3 view_dir = normalize(normalize(-VERTEX + EYE_OFFSET) * mat3(TANGENT * heightmap_flip.x, -BINORMAL * heightmap_flip.y, NORMAL));
		float depth = 1.0 - texture(texture_heightmap, base_uv).r;
		vec2 ofs = base_uv - view_dir.xy * depth * heightmap_scale * 0.01;
		base_uv=ofs;
	}
	
	vec4 clouds_fx = texture(texture_clouds,(base_uv*tile_size) +(Direction * TIME * Speed));
	
	ALBEDO = (albedo.rgb * clouds_fx.rgb);
	ALPHA = (1.0 - clouds_fx.r);

	

}
//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
