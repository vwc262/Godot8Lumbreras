shader_type spatial;

render_mode blend_mix,depth_draw_opaque,cull_back,diffuse_burley,specular_schlick_ggx;
uniform vec4 albedo : source_color;
uniform sampler2D texture_albedo : source_color,filter_linear_mipmap,repeat_enable;
uniform sampler2D texture_clouds : source_color,filter_linear_mipmap,repeat_enable;
uniform float point_size : hint_range(0,128);
uniform float roughness : hint_range(0,1);
uniform sampler2D texture_metallic : hint_default_white,filter_linear_mipmap,repeat_enable;
uniform vec4 metallic_texture_channel;
uniform sampler2D texture_roughness : hint_roughness_r,filter_linear_mipmap,repeat_enable;
uniform float specular;
uniform float metallic;
uniform sampler2D texture_normal : hint_roughness_normal,filter_linear_mipmap,repeat_enable;
uniform sampler2D texture_detail_normal : hint_roughness_normal,filter_linear_mipmap,repeat_enable;
uniform sampler2D mask_normal_texture : hint_roughness_r,filter_linear_mipmap,repeat_enable;
uniform float normal_scale : hint_range(-16,16);
uniform float tile_size = 1;
uniform sampler2D texture_ambient_occlusion : hint_default_white, filter_linear_mipmap,repeat_enable;
uniform vec4 ao_texture_channel;
uniform float ao_light_affect;
uniform sampler2D texture_heightmap : hint_default_black,filter_linear_mipmap,repeat_enable;
uniform float heightmap_scale;
uniform int heightmap_min_layers;
uniform int heightmap_max_layers;
uniform vec2 heightmap_flip;
uniform vec3 uv1_scale;
uniform vec3 uv1_offset;
uniform vec3 uv2_scale;
uniform vec3 uv2_offset;
uniform vec2 Direction = vec2(1.0,0.0);
uniform float Speed = 0.02;
vec3 normal_blend(vec3 b, vec3 d)
{
	return vec3(b.xy+d.xy - 0.5,b.z);
}
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
	vec4 albedo_tex = texture(texture_albedo,base_uv);
	vec4 clouds_fx = texture(texture_clouds,base_uv +(Direction * TIME * Speed));
	ALBEDO = (albedo.rgb * albedo_tex.rgb) * clouds_fx.rgb*vec3(10,10,10);
	float metallic_tex = dot(texture(texture_metallic,base_uv),metallic_texture_channel);
	METALLIC = metallic_tex * metallic;
	vec4 roughness_texture_channel = vec4(1.0,0.0,0.0,0.0);
	float roughness_tex = dot(texture(texture_roughness,base_uv),roughness_texture_channel);
	ROUGHNESS = roughness_tex * roughness;
	SPECULAR = specular;
	vec4 normal_tex = texture(texture_normal,base_uv);
	vec4 detnormal_tex = texture(texture_detail_normal,base_uv*tile_size);
	vec3 mask = texture(mask_normal_texture, UV).rgb;
	NORMAL_MAP = normal_blend(normal_tex.rgb,detnormal_tex.rgb * mask);
	//NORMAL_MAP = texture(texture_normal,base_uv).rgb;
	NORMAL_MAP_DEPTH = normal_scale;
	AO = dot(texture(texture_ambient_occlusion,base_uv),ao_texture_channel);
	AO_LIGHT_AFFECT = ao_light_affect;
}
//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
