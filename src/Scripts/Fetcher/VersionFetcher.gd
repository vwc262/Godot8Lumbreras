extends HTTPRequest
@onready var filePath_version_user = "user://OffLineData/AppVersion.json"
@onready var InfraEstrcuturaPath = "user://OffLineData/OffLineData.json"
@export var urlInfraestructura : String  = "https://www.virtualwavecontrol.com.mx/Core24/crud/ReadSignalsEstacion?idProyecto=7"
@export var url_texturas= "https://www.virtualwavecontrol.com.mx/APK/Cutzamala/texturas/"

var number_of_update_textures = 0

func On_Update_Version(newVersion):
	request_texturas()		
	var dataFile_version_user = get_file(filePath_version_user)
	var toSave = '{"V": %d}' %newVersion
	dataFile_version_user.store_line(toSave) 		
	dataFile_version_user.close()	
	#request(urlInfraestructura)

func request_texturas():
	var current_resource = GlobalTextureResource.get_curret_resource()	
	var total_textures_to_update = current_resource.textures_resources_references.size()
	request_individual_texture(total_textures_to_update)


func request_individual_texture(total:int):
	var current_resource = GlobalTextureResource.get_curret_resource()	
	var currnet_key = current_resource.textures_resources_references.keys()[number_of_update_textures]
	var callable = func (result, _response_code, _headers, body,callable):
		if result == RESULT_SUCCESS:		
			var image_to_create = Image.new()
			image_to_create.load_png_from_buffer(body)
			current_resource.update_texture(currnet_key,ImageTexture.create_from_image(image_to_create))
			number_of_update_textures += 1
			if number_of_update_textures < total:
				request_individual_texture(total)
			else:	
				change_resources() 
		request_completed.disconnect(callable)

	request_completed.connect(callable.bind(callable))
	var texture_url = url_texturas+currnet_key+".png"		
	await request(texture_url)


func _on_request_completed(result, _response_code, _headers, body):
	if(result == RESULT_SUCCESS):
		print("Actualizando Archivo de infraestrucutra")				
		var dataFile = get_file(InfraEstrcuturaPath)
		dataFile.store_string(JSON.stringify(JSON.parse_string(body.get_string_from_utf8())))
		dataFile.close()
		get_tree().reload_current_scene() # Reseteo

func get_file(filePathUpdate:String) -> FileAccess:
	return FileAccess.open(filePathUpdate,FileAccess.WRITE_READ)
	
func change_resources():				
	ResourceSaver.save(GlobalTextureResource.get_curret_resource(),"user://Resources/Texture_Resource.tres")
	GlobalTextureResource.set_saved_ref()
	number_of_update_textures = 0
	UIManager.popUpWindow.showPopUp("Nueva version detectada, Favor de reiniciar la app")

	
	
	
