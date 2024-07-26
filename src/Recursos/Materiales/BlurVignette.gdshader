shader_type canvas_item;

uniform sampler2D screen_texture: hint_screen_texture, repeat_disable, filter_linear_mipmap;
uniform float blur_radius : hint_range(0, 1) = 0.2; // Radius of the blur effect
uniform float blur_amount : hint_range(0, 0.008) = 0; // Strength of the blur effect
uniform float blur_inner : hint_range(0, 1) = 0.6; // Inner edge of the blur effect
uniform float blur_outer : hint_range(0, 1) = 0.66; // Outer edge of the blur effect

// 発射中央部
uniform vec2 blur_center = vec2( 0.5, 0.5 );
// ブラー強度
uniform float blur_power : hint_range( 0, 5 ) ;
// サンプリング回数
uniform int sampling_count : hint_range( 1, 64 ) = 6;


void fragment() {
    vec2 direction = SCREEN_UV - blur_center;
	vec3 c = vec3( 0.0, 0.0, 0.0 );
	float f = 1.0 / float( sampling_count );
	bool is_inside_excluded_area = 
		SCREEN_UV.x > blur_center.x - blur_center.x / 2.0 &&
        SCREEN_UV.x < blur_center.x + blur_center.x / 2.0 &&
        SCREEN_UV.y > blur_center.y - blur_center.y / 2.0 &&
        SCREEN_UV.y < blur_center.y + blur_center.y / 2.0;
	
	for( int i=0; i < sampling_count; i++ ) {		
		if(is_inside_excluded_area){
			COLOR.a = 0.0;
			//COLOR = vec4(0.0,0.0,0.0,1.0);
		}
		else{
		c += texture( screen_texture, SCREEN_UV - blur_amount * direction * float(i) ).rgb * f;
			
		}
	
	}
	COLOR.rgb = c;
}



//shader_type canvas_item;
//
//uniform sampler2D screen_texture: hint_screen_texture, repeat_disable, filter_linear_mipmap;
//uniform float blur_radius : hint_range(0, 1) = 0.2;
//uniform float blur_amount : hint_range(0, 5) = 1.0;
//uniform float blur_inner : hint_range(0, 1) = 0.6;
//uniform float blur_outer : hint_range(0, 1) = 0.66;
//
//void fragment() {
    //vec4 pixelColor = texture(screen_texture, UV);
//
    //vec4 blurColor = vec4(0.0);
    //float totalWeight = 0.0;
//
    //// Simple blur by averaging nearby pixels
    //for (int x = -1; x <= 1; x++) {
        //for (int y = -1; y <= 1; y++) {
            //vec2 offset = vec2(x, y) * blur_radius * blur_amount;
            //vec4 sampleColor = texture(screen_texture, UV + offset);
            //float weight = 1.0 - length(offset);
            //blurColor += sampleColor * weight;
            //totalWeight += weight;
        //}
    //}
    //blurColor /= totalWeight;
//
    //float distance = length(UV - vec2(0.5, 0.5));
    //float blur = smoothstep(blur_inner - blur_radius, blur_outer, distance);
//
    //pixelColor.rgb = mix(blurColor.rgb, pixelColor.rgb, blur);
//
    //COLOR = pixelColor;
//}
