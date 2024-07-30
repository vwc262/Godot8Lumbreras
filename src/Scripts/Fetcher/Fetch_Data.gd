# ApiRequest.gd
extends HTTPRequest

signal datos_actualizados

@export var url_api: String
@export var url_api_update : String

@onready var timer = Timer.new()
@onready var btn_datos_random = $"../DynamicMargins/VB_MainContainer/header_container/BTN_datos_random"

var offLineDataPath = "res://Scripts/OffLineaData/OffLineData.json"
var usando_datos_reales = true # Variable para controlar el toggle


func _ready():
	LoadJsonFile(offLineDataPath)
	#Se configura el timer para que cada determinado tiempo haga la peticion
	connect("request_completed", _solicitud_completada)
	timer.wait_time = 10.0
	timer.one_shot = false
	timer.connect("timeout", _on_timer_timeout)
	add_child(timer)
	timer.start()
	

func iniciar_fetch_api():
	request(url_api_update)
	pass

func _solicitud_completada(result, codigo_respuesta, headers, body):	
	if not usando_datos_reales:
		#_update_data_global(generar_datos_aleatorios(GlobalData.get_data()))
		return
		
	if result == RESULT_SUCCESS:
		var data = JSON.parse_string(body.get_string_from_utf8())		
		updateGLobalData(data)	

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
		#emit_signal("datos_actualizados", jsonData)	
		
func updateGLobalData(jsonData):
	GlobalData.set_Updated_Data(jsonData)
		
func _on_btn_datos_random_pressed():
	usando_datos_reales = not usando_datos_reales
	actualizar_texto_boton()
	if usando_datos_reales:
		iniciar_fetch_api()  # Volver a obtener los datos reales
	else:
		var random_data = generar_datos_aleatorios(GlobalData.get_data())
		_update_data_global(random_data)

func generar_datos_aleatorios(datos_reales):
	var rng = RandomNumberGenerator.new()
	var datos_aleatorios = datos_reales.duplicate(true)  # Crear una copia de los datos reales
#
	for estacion in datos_aleatorios:
		estacion.enlace = rng.randi_range(0, 3)  # Generar un valor aleatorio para enlace (0 o 1)
		estacion.tiempo = generar_fecha_aleatoria(rng)  # Generar una fecha aleatoria
		
		for _signal in estacion.signals:
			_signal.valor = rng.randf_range(0, 3.99)  # Generar un valor aleatorio para la señal
		
	return datos_aleatorios

func generar_fecha_aleatoria(rng):
	var year = 2024
	var month = rng.randi_range(1, 12)
	var day = rng.randi_range(1, 28)
	var hour = rng.randi_range(0, 23)
	var minute = rng.randi_range(0, 59)
	var second = rng.randi_range(0, 59)
	return "%d-%02d-%02dT%02d:%02d:%02d" % [year, month, day, hour, minute, second]

func actualizar_texto_boton():
	if usando_datos_reales:
		btn_datos_random.text = "Usar Datos Aleatorios"
	else:
		btn_datos_random.text = "Usar Datos Reales"

func _update_data_global(estaciones: Array[Estacion]):
	GlobalData.emit_signal("datos_actualizados", estaciones)
