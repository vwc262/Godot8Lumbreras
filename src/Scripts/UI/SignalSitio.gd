# Signal.gd
extends Control

# Referencias a los nodos en la escena
@onready var nombre_se_al = $"VBoxContainer/HBoxContainer/nombre_señal"
@onready var valor_se_al = $"VBoxContainer/HBoxContainer/HBoxContainer/valor_señal"
@onready var semaforo_valor = $VBoxContainer/HBoxContainer/HBoxContainer/progressbar_container/semaforo_valor
@onready var progressbar_container = $VBoxContainer/HBoxContainer/HBoxContainer/progressbar_container
@onready var progress_bar = $VBoxContainer/HBoxContainer/HBoxContainer/progressbar_container/ProgressBar

# Referencia a la señal que se va a mostrar
var signal_ref: Señal

# Diccionario para las unidades de tipo de señal
var unidades = {
	1: "m",
	2: "kg/cm²",
	3: "l/s"
}

# Función para recibir y establecer los datos de la señal
func set_datos(signal_sitio: Señal):
	signal_ref = signal_sitio
	call_deferred("actualizar_datos")

# Función para actualizar los datos mostrados
func actualizar_datos():
	# Obtener la unidad correspondiente al tipo de señal
	var unidad = unidades.get(signal_ref.tipo_signal, "")
	
	# Actualizar el nombre y el valor de la señal
	nombre_se_al.text = signal_ref.nombre
	valor_se_al.text =  str(signal_ref.valor) + " " + unidad if signal_ref.is_dentro_rango() else "---"
	
	# Verificar si el semáforo está presente
	if signal_ref.semaforo != null:
		# Actualizar el texto y la visibilidad del contenedor de la barra de progreso
		semaforo_valor.text = str(signal_ref.valor) + " de " + str(signal_ref.semaforo.critico) + " " + unidad
		progressbar_container.visible = true
		
		# Establecer los valores mínimo y máximo de la barra de progreso
		progress_bar.min_value = float(signal_ref.semaforo.normal)
		progress_bar.max_value = float(signal_ref.semaforo.critico)
		progress_bar.value = float(signal_ref.valor)
		
		# Cambiar el color de la barra de progreso según el valor de la señal
		if signal_ref.valor > signal_ref.semaforo.normal and signal_ref.valor <= signal_ref.semaforo.preventivo:
			progress_bar.modulate = Color(1, 1, 0) # Amarillo
		elif signal_ref.valor > signal_ref.semaforo.preventivo:
			progress_bar.modulate = Color(1, 0, 0) # Rojo
		else:
			progress_bar.modulate = Color(0, 1, 0) # Verde
	else:
		# Ocultar el contenedor de la barra de progreso si el semáforo no está presente
		progressbar_container.visible = false
