shader_type canvas_item;

uniform sampler2D screen_texture: hint_screen_texture, repeat_disable, filter_linear_mipmap;
uniform float blur_amount : hint_range(0, 0.008) = 0; // Strength of the blur effect

// 発射中央部
uniform vec2 blur_center = vec2( 0.5, 0.5 );
// サンプリング回数
uniform int sampling_count : hint_range( 1, 64 ) = 6;
uniform float distance_power : hint_range( 0.0, 1.0 ) = 0.723;


void fragment() {
    vec2 direction = SCREEN_UV - blur_center;
	vec3 c = vec3( 0.0, 0.0, 0.0 );
	float f = 1.0 / float( sampling_count );
		
    float pct =  distance(UV,vec2(0.5));
    vec2 gradient = vec2(pct*distance_power);
	
	for( int i=0; i < sampling_count; i++ ) {		
		c += texture( screen_texture, SCREEN_UV - blur_amount * gradient * float(i) ).rgb * f;
	}
	
	COLOR.rgb = c;
}
