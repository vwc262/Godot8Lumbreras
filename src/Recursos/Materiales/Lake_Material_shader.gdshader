shader_type spatial;
render_mode unshaded;

uniform vec4 albedo : source_color;
uniform sampler2D texture_albedo : source_color,filter_linear_mipmap,repeat_enable;
uniform sampler2D texture_waves : source_color,filter_linear_mipmap,repeat_enable;
uniform sampler2D texture_clouds : source_color,filter_linear_mipmap,repeat_enable;
uniform sampler2D texture_heightmap : hint_default_black,filter_linear_mipmap,repeat_enable;
uniform float heightmap_scale;
uniform float tile_size = 1;
//uniform int heightmap_min_layers;
//uniform int heightmap_max_layers;
uniform vec2 heightmap_flip;
uniform vec3 uv1_scale;
uniform vec3 uv1_offset;
//uniform vec3 uv2_scale;
//uniform vec3 uv2_offset;
uniform vec2 Direction = vec2(1.0,0.0);
uniform float Speed = 0.02;

void vertex() {
	// Called for every vertex the material is visible on.
		UV=UV*uv1_scale.xy+uv1_offset.xy;
}

void fragment() {
	// Called for every pixel the material is visible on.
		vec2 base_uv = UV;
		vec2 base_uv2 = UV2;
	{
		vec3 view_dir = normalize(normalize(-VERTEX + EYE_OFFSET) * mat3(TANGENT * heightmap_flip.x, -BINORMAL * heightmap_flip.y, NORMAL));
		float depth = 1.0 - texture(texture_heightmap, base_uv).r;
		vec2 ofs = base_uv - view_dir.xy * depth * heightmap_scale * 0.01;
		base_uv=ofs;
		vec2 ofs2 = base_uv2 - view_dir.xy * depth * heightmap_scale * 0.01;
		base_uv2=ofs2;
	}
	vec4 albedo_tex = texture(texture_albedo,base_uv);
	vec4 clouds_fx = texture(texture_clouds,base_uv2 +(Direction * TIME * Speed));
	vec4 waves_tex = texture(texture_waves,(base_uv*tile_size +(Direction * TIME * Speed)));
	vec4 waves_tex2 = texture(texture_waves,(base_uv*tile_size +(vec2(-1.0,1) * TIME * -Speed)));
	ALBEDO = (albedo.rgb * albedo_tex.rgb) * clouds_fx.rgb* waves_tex.rgb * waves_tex2.rgb;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
