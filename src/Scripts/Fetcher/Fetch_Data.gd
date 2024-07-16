extends HTTPRequest

signal datos_actualizados

@export var url_api: String

# Timer para realizar solicitudes periódicamente
@onready var timer = Timer.new()

func _ready():
	# Conectar la señal 'request_completed' al método '_solicitud_completada'
	connect("request_completed", _solicitud_completada)

	# Configurar el Timer
	timer.wait_time = 10.0 # 60 segundos
	timer.one_shot = false # Repetir indefinidamente
	timer.connect("timeout", _on_timer_timeout)
	add_child(timer) # Agregar el Timer como hijo del nodo actual
	timer.start() # Iniciar el Timer

	iniciar_fetch_api() # Realizar la primera solicitud inmediatamente

func iniciar_fetch_api():
	# Realizar la solicitud HTTP
	request(url_api)

func _solicitud_completada(result, codigo_respuesta, headers, body):
	if result == RESULT_SUCCESS:
		var data = JSON.parse_string(body.get_string_from_utf8())
		# Emitir la señal 'datos_actualizados' con los datos recibidos
		emit_signal("datos_actualizados", data)
		# Imprimir los datos recibidos
		print("Datos recibidos:", data)
		# Guardar los datos en el AutoLoad
		DataStore.set_data(data)
	else:
		print("Error en la solicitud HTTP, Código de respuesta:", codigo_respuesta)

func _on_timer_timeout():
	# Iniciar una nueva solicitud HTTP cuando el Timer expira
	iniciar_fetch_api()
