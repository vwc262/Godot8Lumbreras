shader_type sky;
uniform vec3 skyColor : source_color;
uniform vec3 horizonColor1 : source_color;
uniform vec3 horizonColor2 : source_color;
uniform float offsetHorizontalColor: hint_range(0,1,0.01) = 0.4;
uniform sampler2D skyTexture;
void sky() {
    // Called for every visible pixel in the sky background, as well as all pixels
    // in the radiance cubemap.
    float col1 = clamp(EYEDIR.y / .3,0.1,1.0) + offsetHorizontalColor;
    float col2 = clamp(EYEDIR.y / .3,0.1,1.0) + offsetHorizontalColor;

    vec3 finalColor1 = mix(horizonColor1,skyColor,col1);
    vec3 finalColor2 = mix(horizonColor2,skyColor,col2);
    vec3 finalColor3 = mix(finalColor1,finalColor2, 0.9f);
    COLOR = finalColor3;
    //COLOR =texture(skyTexture,vec2(SKY_COORDS.x + TIME / 100.0,SKY_COORDS.y)).rgb;
}
