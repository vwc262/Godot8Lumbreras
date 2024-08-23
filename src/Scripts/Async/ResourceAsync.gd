extends Thread
class_name AsyncResourceSaver

var _resource : Resource
var _path_to_save : String

func _init(resource_to_save:Resource,path:String) -> void:
	_resource = resource_to_save
	_path_to_save = path	

func _save_async(callback:Callable):
	ResourceSaver.save(_resource,_path_to_save)		
	callback.call()
