# ApiRequest.gd
extends HTTPRequest

signal datos_actualizados

@export var url_api: String

@onready var timer = Timer.new()

func _ready():
	connect("request_completed", _solicitud_completada)

	timer.wait_time = 60.0
	timer.one_shot = false
	timer.connect("timeout", _on_timer_timeout)
	add_child(timer)
	timer.start()

	iniciar_fetch_api()

func iniciar_fetch_api():
	request(url_api)

func _solicitud_completada(result, codigo_respuesta, headers, body):
	if result == RESULT_SUCCESS:
		var data = JSON.parse_string(body.get_string_from_utf8())
		var parsed_data = data
		GlobalData.set_data(parsed_data)
		emit_signal("datos_actualizados", parsed_data)
		# print("Datos recibidos y almacenados:", parsed_data)

	else:
		print("Error en la solicitud HTTP, Código de respuesta:", codigo_respuesta)

func _on_timer_timeout():
	iniciar_fetch_api()
