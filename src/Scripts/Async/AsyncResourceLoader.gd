extends Thread
class_name AsyncResourceLoader

var _path_to_load : String

func _init(path:String) -> void:	
	_path_to_load = path	

func _save_async(callback_func:Callable) :
	var res =  load(_path_to_load)
	if is_instance_valid(res):
		callback_func.call(res)
