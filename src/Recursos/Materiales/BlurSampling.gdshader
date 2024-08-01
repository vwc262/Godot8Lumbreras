shader_type canvas_item;

uniform sampler2D screen_texture: hint_screen_texture, repeat_disable, filter_linear_mipmap;
uniform float blur_amount : hint_range(0, 0.008) = 0; // Strength of the blur effect



uniform vec2 blur_center = vec2( 0.5, 0.5 );
uniform float blur_power : hint_range( 0, 5 ) ;
uniform int sampling_count : hint_range( 1, 64 ) = 6;

uniform vec4 color1 : source_color;
uniform vec4 color2 : source_color;
uniform vec4 color3 : source_color;
uniform vec4 color4 : source_color;
uniform vec4 color5 : source_color;
uniform vec4 color6 : source_color;
uniform vec2 squishness = vec2(1.0); // how squashed your gradient is
uniform float step1 : hint_range(0.0,1.0) = 0.159;
uniform float step2 : hint_range(0.0,1.0) = 0.182;
uniform float step3 : hint_range(0.0,1.0) = 0.233;
uniform float step4 : hint_range(0.0,1.0) = 0.264;
uniform float step5 : hint_range(0.0,1.0) = 0.265;
uniform float step6 : hint_range(0.0,1.0) = 0.266;
uniform float size: hint_range(0.0,5.0) = 1.0;

vec4 get_gradiente(vec2 screen_uv){
	float dist = distance(blur_center*squishness,screen_uv *squishness);
	vec4 color = mix(color1, color2, smoothstep(step1*size, step2*size, dist));
	color = mix(color, color3, smoothstep(step2*size, step3*size, dist));
	color = mix(color, color4, smoothstep(step3*size, step4*size, dist));
	color = mix(color, color5, smoothstep(step4*size, step5*size, dist));
	color = mix(color, color6, smoothstep(step5*size, step6*size, dist));
	return color;
	//return vec4(0.0,0.0,0.0,0.0);
}

void fragment() {
	vec4 colorGradiente = vec4(0.0);
    vec2 direction = SCREEN_UV - blur_center;
	vec4 c = vec4( 0.0, 0.0, 0.0,0.0 );
	float f = 1.0 / float( sampling_count );	
	for( int i=0; i < sampling_count; i++ ) {		
		c += texture( screen_texture, SCREEN_UV - blur_amount * direction * float(i) ).rgba * f;
	    colorGradiente = get_gradiente(SCREEN_UV).rgba;			
		c.a *= colorGradiente.a;							
	    //c = colorGradiente;
	}
	COLOR.rgba = c;
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
