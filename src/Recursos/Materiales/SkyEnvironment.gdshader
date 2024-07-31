shader_type sky;
uniform vec3 skyColor : source_color;
uniform vec3 horizonColor : source_color;
uniform float offsetHorizontalColor: hint_range(0,1,0.1) = 0.4;
uniform sampler2D skyTexture;
void sky() {
	// Called for every visible pixel in the sky background, as well as all pixels
	// in the radiance cubemap.
	float col = clamp(EYEDIR.y / .3,0.1,1.0) + offsetHorizontalColor;
	vec3 finalColor = mix(horizonColor,skyColor,col);
	COLOR = finalColor;
	//COLOR =texture(skyTexture,vec2(SKY_COORDS.x + TIME / 100.0,SKY_COORDS.y)).rgb;
}
