# ApiRequest.gd
extends HTTPRequest

signal datos_actualizados

@export var url_api: String

@onready var timer = Timer.new()

var offLineDataPath = "res://Scripts/OffLineaData/OffLineData.json"

func _ready():
	LoadJsonFile(offLineDataPath)
	#Se configura el timer para que cada determinado tiempo haga la peticion
	connect("request_completed", _solicitud_completada)
	timer.wait_time = 60.0
	timer.one_shot = false
	timer.connect("timeout", _on_timer_timeout)
	add_child(timer)
	timer.start()
	

func iniciar_fetch_api():
	request(url_api)

func _solicitud_completada(result, codigo_respuesta, headers, body):
	if result == RESULT_SUCCESS:
		var data = JSON.parse_string(body.get_string_from_utf8())		
		setDataToGlobal(data)	

	else:
		print("Error en la solicitud HTTP, Código de respuesta:", codigo_respuesta)

func _on_timer_timeout():
	iniciar_fetch_api()
	
func LoadJsonFile(filePath:String):
	if FileAccess.file_exists(filePath):
		var dataFile = FileAccess.open(filePath,FileAccess.READ)
		var parsedResult =JSON.parse_string(dataFile.get_as_text())
		setDataToGlobal(parsedResult)
		iniciar_fetch_api()
	
		
func setDataToGlobal(jsonData):
		GlobalData.set_data(jsonData)
		emit_signal("datos_actualizados", jsonData)		
