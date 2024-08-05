shader_type spatial;
render_mode cull_disabled; //deja ver ambas caras

uniform vec3 base_color : source_color;
uniform vec3 inside_color : source_color;

uniform float dissolve_amount : hint_range(0.0,1.0) = 0.0;
uniform sampler2D noise_texture;
uniform vec3 glow_color : source_color = vec3(1.0,0.0,0.0);
uniform float glow_intensity = 5.0;
uniform float glow_border_width : hint_range(0.0,0.25) = 0.05;
uniform float glow_border_smoothness : hint_range(0.0,1.0) = 0.04;

uniform bool use_texture = false;

uniform sampler2D texture_color : source_color;

void fragment() {	
	float dissolve_noise = texture(noise_texture,UV).r;
	float border_mask = 0.0;
	if(dissolve_amount > 0.0){
		float border_size = dissolve_amount + glow_border_width;
		border_mask = 1.0 - smoothstep(border_size - glow_border_smoothness,border_size + glow_border_smoothness,dissolve_noise);
	}		
	vec3 surface_color = mix( use_texture ? texture(texture_color,UV).rgb : base_color,vec3(0.0),border_mask); 
	if(!FRONT_FACING){
		surface_color = inside_color;
	}
	
	vec3 surface_emission = mix(vec3(0.0),glow_color,border_mask);
	ALBEDO = surface_color;	
	EMISSION = surface_emission  * glow_intensity;
	ROUGHNESS = 0.5;
	ALPHA = dissolve_noise;
	ALPHA_SCISSOR_THRESHOLD = dissolve_amount;
}
