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
	if !is_instance_valid(saved_ref):
		var async_load = AsyncResourceLoader.new("user://Resources/Texture_Resource.tres")
		async_load.start(async_load._save_async.bind(set_instance_value),Thread.PRIORITY_NORMAL)
		async_load.wait_to_finish()		

func set_instance_value(resource_loaded:Resource):
	saved_ref = resource_loaded
	print("Instancia lista!")
	
