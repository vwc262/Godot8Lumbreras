extends HTTPRequest
@onready var filePath = "res://Scripts/OffLineaData/AppVersion.json"
@onready var InfraEstrcuturaPath = "res://Scripts/OffLineaData/OffLineData.json"
@export var urlInfraestructura : String  = "https://www.virtualwavecontrol.com.mx/Core24/crud/ReadSignalsEstacion?idProyecto=7"



func On_Update_Version(newVersion):
	print("Actualizando a la version " , newVersion)	
	var dataFile = get_file(filePath)
	var parsedResult =JSON.parse_string(dataFile.get_as_text())
	var toSave = '{"V": %d}' %newVersion
	dataFile.store_line(toSave) 		
	dataFile.close()	
	request(urlInfraestructura)
			


func _on_request_completed(result, response_code, headers, body):
	if(result == RESULT_SUCCESS):
		print("Actualizando Archivo de infraestrucutra")				
		var dataFile = get_file(InfraEstrcuturaPath)
		dataFile.store_string(JSON.stringify(JSON.parse_string(body.get_string_from_utf8())))
		dataFile.close()
		get_tree().reload_current_scene() # Reseteo

func get_file(filePath:String) -> FileAccess:
	return FileAccess.open(filePath,FileAccess.WRITE_READ)
	
	
	
