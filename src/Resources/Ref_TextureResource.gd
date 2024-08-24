extends Resource

class_name Texture_Resources
@export var textures_resources_references  = {}


enum E_TextureKey {header}

	
func update_texture(key:String,texture:Texture):
	textures_resources_references[key] = texture

func get_texture(key:String) -> Texture:		
	return textures_resources_references[key]
