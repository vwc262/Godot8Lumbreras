shader_type canvas_item;

uniform float sizeX = 0.0;
uniform float sizeY = 0.0;
uniform float velocidad = 0.0;
uniform float framex = 0.0;
uniform float progress : hint_range(0.0, 32.0) = 0.0; 
uniform bool use_time;

uniform vec4 colorToAdd : source_color;



vec2 flipbook(vec2 uv, vec2 size){
	float result  = floor( mod(use_time ? TIME * velocidad : progress, (size.x * size.y)) );
	vec2 frame_size = vec2(1.0, 1.0) / vec2(size.x, size.y);
	vec2 frame = fract(uv / size) + frame_size;		
	frame.x += ( (result / size.x) - frame_size.x * floor(result/size.x) * size.x ) - frame_size.x;
	frame.y += (frame_size.y * floor(result/size.x) ) - frame_size.y ;	
	return frame;	
}

void fragment()
{	
	vec2 flip_uv = flipbook(UV, vec2(sizeX, sizeY));
	vec4 flip_texture = texture(TEXTURE, flip_uv);		
	COLOR = flip_texture;	
}

