extends Control

class_name SegnalLista

#region VARIABLES DEL NIVEL
@onready var lbl_nombre_signal = $main_container/HBoxContainer/VBoxContainer/nivel_container/nivel_nombre_container/HBoxContainer/lbl_nivel_nombre
@onready var lbl_valor_min = $main_container/HBoxContainer/VBoxContainer/nivel_container/nivel_progressbar_container/VBoxContainer/HBoxContainer/lbl_nivel_valor_min
@onready var lbl_valor_max = $main_container/HBoxContainer/VBoxContainer/nivel_container/nivel_progressbar_container/VBoxContainer/HBoxContainer/lbl_nivel_valor_max
@onready var lbl_valor = $main_container/HBoxContainer/VBoxContainer/nivel_container/nivel_valor_container/lbl_nivel_valor
@onready var progress_bar = $main_container/HBoxContainer/VBoxContainer/nivel_container/nivel_progressbar_container/VBoxContainer/ProgressBar

#endregion

#region VARIABLES DE LAS DEMAS SEÑALES
@onready var lbl_nombre_signal_presion = $main_container/HBoxContainer/VBoxContainer/presion_gasto_container/HBoxContainer/presion_container/HBoxContainer/lbl_presion_nombre
@onready var lbl_presion_valor = $main_container/HBoxContainer/VBoxContainer/presion_gasto_container/HBoxContainer/presion_container/HBoxContainer/presion_valor_container/presion_valor
@onready var lbl_nombre_signal_gasto = $main_container/HBoxContainer/VBoxContainer/presion_gasto_container/HBoxContainer/gasto_container/HBoxContainer2/lbl_gasto_nombre
@onready var lbl_gasto_valor = $main_container/HBoxContainer/VBoxContainer/presion_gasto_container/HBoxContainer/gasto_container/HBoxContainer2/gasto_valor_container/gasto_valor
@onready var lbl_totalizado_nombre = $main_container/HBoxContainer/VBoxContainer/totalizado_container/lbl_totalizado_nombre
@onready var lbl_totalizado_valor = $main_container/HBoxContainer/VBoxContainer/totalizado_container/totalizado_valor_container/lbl_totalizado_valor

#endregion

# Referencia a la señal que se va a mostrar
var signal_ref: Array[Señal] = []
var id_estacion: int
var set_maximos=false

# Diccioario para las unidades de tipo de señal
var unidades = {
	1: "m",
	2: "kg/cm²",
	3: "l/s",
	4: "m³"
}

func set_maximos_minimos(senal:Señal):
	if !set_maximos:
		progress_bar.max_value = senal.semaforo["critico"]
		progress_bar.min_value = 0.6
	set_maximos = true	
	

# Función para recibir y establecer los datos de la señal
func set_datos(estacion: Estacion):
	id_estacion = estacion.id_estacion
	signal_ref.assign(estacion.signals.values())
	call_deferred("actualizar_datos")

func actualizar_datos():
	for _signal in signal_ref:
		var unidad = unidades.get(_signal.tipo_signal, "")
		
		if _signal.tipo_signal == 1:
			lbl_nombre_signal.text = _signal.nombre
			lbl_valor.text = str(_signal.valor) + " " + unidad if _signal.is_dentro_rango() else "---"
		elif _signal.tipo_signal == 2:
			lbl_nombre_signal_presion.text = _signal.nombre
			lbl_presion_valor.text = str(_signal.valor) + " " + unidad if _signal.is_dentro_rango() else "---"
		elif _signal.tipo_signal == 3:
			lbl_nombre_signal_gasto.text = _signal.nombre
			lbl_gasto_valor.text = str(_signal.valor) + " " + unidad if _signal.is_dentro_rango() else "---"
		elif _signal.tipo_signal == 4:
			lbl_totalizado_nombre.text = _signal.nombre
			lbl_totalizado_valor.text = str(_signal.valor) + " " + unidad if _signal.is_dentro_rango() else "---"
		
		if _signal.semaforo != null:
			set_progress_bar(_signal, unidad)

				
# Función para establecer la barra de progreso
func set_progress_bar(_signal: Señal, unidad):
	set_maximos_minimos(_signal)
	##Asegurarse de que el valor mínimo visible siempre esté presente	
	var display_value =  clamp(_signal.valor,progress_bar.min_value,progress_bar.max_value)	#
	lbl_valor_min.text = str(_signal.semaforo["normal"]) + " " + unidad
	lbl_valor_max.text = str(_signal.semaforo["critico"]) + " " + unidad
#
	# Cambiar el color de la barra de progreso según el valor de la señal
	if _signal.valor > _signal.semaforo.normal and _signal.valor <= _signal.semaforo.preventivo:
		progress_bar.modulate = Color(1, 1, 0) # Amarillo
	elif _signal.valor > _signal.semaforo.preventivo:
		progress_bar.modulate = Color(1, 0, 0) # Rojo
	else:
		progress_bar.modulate = Color(0, 1, 0) # Verde

	#Usar Tween para animar la barra de progreso
	var tween = TweenManager.init_tween(_on_tween_finished.bind(display_value))
	tween.tween_property(progress_bar, "value", display_value, 1)

	
func _on_tween_finished(_valor_a_poner): pass

# Función general para manejar la lógica compartida de los botones
func manejar_btn_presionado(_mostrar_graficador: bool):
	UIManager.seleccionar_sitio_id(id_estacion)
	
	if UIManager.current_selected_site:
		SceneManager.scroll_scene(SceneManager.TIPO_NIVEL.PARTICULAR,id_estacion)
		NavigationManager.set_lastid_selected(id_estacion)
		UIManager.mostrar_particular()

# Llamada al presionar el botón de graficador
func _on_btn_graficador_pressed():
	#manejar_btn_presionado(true)
	NavigationManager.set_lastid_selected(id_estacion)
	SceneManager.scroll_scene(SceneManager.TIPO_NIVEL.GRAFICADOR,SceneManager.idSceneGraficador)

# Llamada al presionar el botón de particular
func _on_btn_particular_pressed():
	manejar_btn_presionado(false)

# Función para actualizar el texto del botón de particular/graficador
func _actualizar_texto_boton_particular():
	
	if UIManager.is_graficador_visible():
		UIManager.btn_graficador.text = "Particular"
	else:
		UIManager.btn_graficador.text = "Graficador"

