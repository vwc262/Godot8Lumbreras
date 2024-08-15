// NOTE: Shader automatically converted from Godot Engine 4.2.2.stable's StandardMaterial3D.

shader_type spatial;

uniform sampler2D texture_albedo : source_color,filter_linear_mipmap,repeat_enable;
uniform vec4 color: source_color = vec4(0 ,0 ,0 ,1);
uniform float offset: hint_range(0.0, 1.0, 0.1) = 0.5;
uniform float alpha_scissor: hint_range(0.0, 1.0, 0.1) = 0.5;


void fragment() {
	vec2 base_uv = UV;
	vec4 albedo_tex = texture(texture_albedo, base_uv);
	if(UV.x < offset){
		ALBEDO = color.rgb * albedo_tex.rgb;
	} else {
		discard;
	}
	ALPHA_SCISSOR_THRESHOLD = alpha_scissor;
}