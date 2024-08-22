extends Node

var does_exist = false
var ref_texture : Texture_Resources = preload("Texture_Resource.tres")	
var saved_ref : Texture_Resources = null

func _ready() -> void:
	create_resource_directory()	
	
func create_resource_directory():
	if !DirAccess.dir_exists_absolute("user://Resources"):
		DirAccess.make_dir_absolute("user://Resources")	
	set_saved_ref()		
	
	
#func update_texture(key:String,texture:Texture):
	#var resource = get_curret_resource()
	#resource.update_texture(key,texture)
	
func get_curret_resource() -> Texture_Resources:
	return ref_texture if !is_instance_valid(saved_ref) else saved_ref	
	
func set_saved_ref():
	if saved_ref == null:
		saved_ref = load("user://Resources/Texture_Resource.tres")
