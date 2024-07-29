shader_type canvas_item;

#define iResolution 1.0/SCREEN_PIXEL_SIZE
#define iTime TIME


uniform float strength: hint_range(0.0, 5.0, 0.1) = 1.0;
uniform float speed: hint_range(0.0, 10.0, 0.1) = 1.0;
uniform vec2 disp = vec2(1.0, 1.0);
uniform sampler2D screen_texture: hint_screen_texture, repeat_disable, filter_linear_mipmap;
uniform float noiseWeight: hint_range(0.0, 0.2, 0.001) = 0.05;
uniform float color_power_normalized: hint_range(0.0, 1.0, 0.1) = 0.0;

vec2 GetGradient(vec2 intPos, float t) {
    
    // Uncomment for calculated rand
    //float rand = fract(sin(dot(intPos, vec2(12.9898, 78.233))) * 43758.5453);;

    // Texture-based rand (a bit faster on my GPU)
    float rand = texture(screen_texture, intPos / 64.0).r;
    
    // Rotate gradient: random starting rotation, random rotation rate
    float angle = 6.283185 * rand + 4.0 * t * rand;
    return vec2(cos(angle), sin(angle));
}

float Pseudo3dNoise(vec3 pos) {
    vec2 i = floor(pos.xy);
    vec2 f = pos.xy - i;
    vec2 blend = f * f * (3.0 - 2.0 * f);
    float noiseVal = 
        mix(
            mix(
                dot(GetGradient(i + vec2(0, 0), pos.z), f - vec2(0, 0)),
                dot(GetGradient(i + vec2(1, 0), pos.z), f - vec2(1, 0)),
                blend.x),
            mix(
                dot(GetGradient(i + vec2(0, 1), pos.z), f - vec2(0, 1)),
                dot(GetGradient(i + vec2(1, 1), pos.z), f - vec2(1, 1)),
                blend.x),
        blend.y
    );
    return noiseVal / 0.7; // normalize to about [-1..1]
}

void fragment() { 
	float ratio = SCREEN_PIXEL_SIZE.x / SCREEN_PIXEL_SIZE.y;
	//vec2 noise_uv = UV / vec2(ratio, 1.0);
	vec2 noise_uv = SCREEN_UV / vec2(ratio, 1.0);
    float noiseVal = 1.0 * Pseudo3dNoise(vec3(noise_uv * 2.0 * strength, iTime * speed));
    
    //vec2 uv = UV;
    vec2 uv = SCREEN_UV;
    uv.x += noiseVal * noiseWeight * disp.x;
    uv.y += noiseVal * noiseWeight * disp.y;
    vec3 col = texture(screen_texture,uv).rgb;
    
    COLOR.rgb = vec3(col) * vec3(1.0-color_power_normalized);
}