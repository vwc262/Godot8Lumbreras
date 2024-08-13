shader_type spatial;

render_mode unshaded;
uniform vec4 albedo : source_color;
uniform sampler2D texture_albedo : source_color,filter_linear_mipmap,repeat_enable;
uniform sampler2D texture_detail_ao : hint_default_white, filter_linear_mipmap,repeat_enable;
uniform float tile_size = 1;
uniform sampler2D texture_ambient_occlusion : hint_default_white, filter_linear_mipmap,repeat_enable;
uniform vec4 ao_texture_channel;
uniform float ao_light_affect;
uniform sampler2D texture_heightmap : hint_default_black,filter_linear_mipmap,repeat_enable;
uniform float heightmap_scale;
uniform vec2 heightmap_flip;
uniform vec3 uv1_scale;
uniform vec3 uv1_offset;



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
	vec4 albedo_tex = texture(texture_albedo,base_uv*tile_size);
	vec4 shadow_tex = texture(texture_detail_ao,base_uv);
	ALBEDO = (albedo.rgb * albedo_tex.rgb) * shadow_tex.rgb;

	
	//NORMAL_MAP = texture(texture_normal,base_uv).rgb;
	AO = dot(texture(texture_ambient_occlusion,base_uv),ao_texture_channel);
	AO_LIGHT_AFFECT = ao_light_affect;
}
//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
