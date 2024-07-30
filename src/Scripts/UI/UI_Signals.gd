extends Control

#region VARIABLES DEL NIVEL
@onready var lbl_nombre_signal = $Panel/HBoxContainer/VBoxContainer/nivel_container/nivel_container/nombre_container/lbl_nombre_signal
@onready var lbl_valor_min = $Panel/HBoxContainer/VBoxContainer/nivel_container/nivel_container/progressbar_container/VBoxContainer/valores_progress/HBoxContainer/lbl_valor_min
@onready var lbl_valor_max = $Panel/HBoxContainer/VBoxContainer/nivel_container/nivel_container/progressbar_container/VBoxContainer/valores_progress/HBoxContainer/lbl_valor_max
@onready var lbl_valor = $Panel/HBoxContainer/VBoxContainer/nivel_container/nivel_container/valor_container/lbl_valor
@onready var progress_bar = $Panel/HBoxContainer/VBoxContainer/nivel_container/nivel_container/progressbar_container/VBoxContainer/ProgressBar

#endregion

#region VARIABLES DE LAS DEMAS SEÑALES
@onready var lbl_nombre_signal_presion = $"Panel/HBoxContainer/VBoxContainer/señales_container/HBoxContainer/presion_container/HBoxContainer/Panel/lbl_nombre_signal_presion"
@onready var lbl_presion_valor = $"Panel/HBoxContainer/VBoxContainer/señales_container/HBoxContainer/presion_container/HBoxContainer/Panel2/lbl_presion_valor"
@onready var lbl_nombre_signal_gasto = $"Panel/HBoxContainer/VBoxContainer/señales_container/HBoxContainer/gasto_container/HBoxContainer/Panel/lbl_nombre_signal_gasto"
@onready var lbl_gasto_valor = $"Panel/HBoxContainer/VBoxContainer/señales_container/HBoxContainer/gasto_container/HBoxContainer/Panel2/lbl_gasto_valor"
#endregion

# Referencia a la señal que se va a mostrar
var signal_ref : Array[Señal] = []

# Diccionario para las unidades de tipo de señal
var unidades = {
	1: "m",
	2: "kg/cm²",
	3: "l/s"
}

# Función para recibir y establecer los datos de la señal
func set_datos(estacion:Estacion):
	signal_ref.assign(estacion.signals.values())  
	call_deferred("actualizar_datos")

func actualizar_datos():	
	for _signal in signal_ref:
		
		# Obtener la unidad correspondiente al tipo de señal
		var unidad = unidades.get(_signal.tipo_signal, "")
				
		if _signal.tipo_signal == 1:
			lbl_nombre_signal.text = _signal.nombre			
			lbl_valor.text = str(_signal.valor) + " " + unidad
			
		elif _signal.tipo_signal == 2: 
			lbl_nombre_signal_presion.text = _signal.nombre
			lbl_presion_valor.text = str(_signal.valor) + " " + unidad
		elif _signal.tipo_signal == 3:
			lbl_nombre_signal_gasto.text = _signal.nombre
			lbl_gasto_valor.text = str(_signal.valor) + " " + unidad
			
			# Verificar si el semáforo está presente
		if _signal.semaforo != null:
			# Actualizar el texto y la visibilidad del contenedor de la barra de progreso
			lbl_valor_min.text = "Min: " + str(_signal.semaforo.normal) + " " + unidad
			lbl_valor_max.text = "Max: " + str(_signal.semaforo.critico) + " " + unidad
			
			# Establecer los valores mínimo y máximo de la barra de progreso
			progress_bar.min_value = float(_signal.semaforo.normal)
			progress_bar.max_value = float(_signal.semaforo.critico)
			progress_bar.value = float(_signal.valor)
			
			# Cambiar el color de la barra de progreso según el valor de la señal
			if _signal.valor > _signal.semaforo.normal and _signal.valor <= _signal.semaforo.preventivo:
				progress_bar.modulate = Color(1, 1, 0) # Amarillo
			elif _signal.valor > _signal.semaforo.preventivo:
				progress_bar.modulate = Color(1, 0, 0) # Rojo
			else:
				progress_bar.modulate = Color(0, 1, 0) # Verde
	
