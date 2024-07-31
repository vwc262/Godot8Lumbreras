extends Control

@onready var btn_lista = $VBoxContainer/main_container/detalles_container/VBoxContainer/botones_container/HBoxContainer/btn_lista
@onready var sitio_detalles = $VBoxContainer/main_container/detalles_container/VBoxContainer/sitio_detalles
@onready var ui_particular = $"."

@onready var datos_sitios: Array[Estacion] = GlobalData.get_data()

@onready var lbl_header_nombre = $VBoxContainer/header_container/HBoxContainer/header_nombre_container/lbl_header_nombre
@onready var fondo_render_material : Material = $VBoxContainer/main_container/fondo_render.material

@onready var texture_enlace = $VBoxContainer/header_container/HBoxContainer/header_icono_container/texture_enlace
@onready var lbl_presion = $VBoxContainer/main_container/detalles_container/VBoxContainer/sitio_detalles/VBoxContainer/HBoxContainer/Panel/HBoxContainer/Presion_container/HBoxContainer/Panel2/lbl_presion
@onready var lbl_presion_valor = $VBoxContainer/main_container/detalles_container/VBoxContainer/sitio_detalles/VBoxContainer/HBoxContainer/Panel/HBoxContainer/Presion_container/HBoxContainer/Panel/lbl_presion_valor
@onready var lbl_gasto = $"VBoxContainer/main_container/detalles_container/VBoxContainer/sitio_detalles/VBoxContainer/HBoxContainer/Panel/HBoxContainer/Gasto_container/HBoxContainer/Panel2/lbl_gasto"
@onready var lbl_gasto_valor = $"VBoxContainer/main_container/detalles_container/VBoxContainer/sitio_detalles/VBoxContainer/HBoxContainer/Panel/HBoxContainer/Gasto_container/HBoxContainer/Panel/lbl_gasto_valor"
@onready var lbl_fecha = $VBoxContainer/main_container/detalles_container/VBoxContainer/sitio_detalles/VBoxContainer/fecha_container/lbl_fecha

@onready var progress_bar = $VBoxContainer/main_container/progress_bar_container/ProgressBar
@onready var lbl_progress_bar_valor_min = $VBoxContainer/main_container/progress_bar_container/progress_bar_marcadores_container/min_container/lbl_progress_bar_valor_min
@onready var lbl_progress_bar_valor_max = $VBoxContainer/main_container/progress_bar_container/progress_bar_marcadores_container/max_container/lbl_progress_bar_valor_max
@onready var lbl_nivel_nombre = $VBoxContainer/main_container/progress_bar_container/lbl_nivel_nombre
@onready var lbl_valor = $VBoxContainer/main_container/progress_bar_container/ProgressBar/lbl_valor



@export var new_icon: Texture2D
@export var texture_online: Texture2D
@export var texture_offline: Texture2D


var original_icon: Texture2D
var is_new_icon_active: bool = false
var is_hidden: bool = false

# Diccionario para las unidades de tipo de señal
var unidades = {
	1: "m",
	2: "kg/cm²",
	3: "l/s"
}
func _ready():
	
	original_icon = btn_lista.icon  # Guarda el ícono original
	btn_lista.connect("pressed", _on_btn_lista_pressed)
	NavigationManager.connect("Go_TO", _compare_and_print_selected_site)
	GlobalData.connect("datos_actualizados", _on_datos_actualizados)
	

func _on_datos_actualizados(estaciones: Array[Estacion]):
	_compare_and_print_selected_site(estaciones)


func _on_btn_lista_pressed():
	if is_new_icon_active:
		btn_lista.icon = original_icon
		_show_lista_sitios()
	else:
		btn_lista.icon = new_icon
		_hide_lista_sitios()
	
	is_new_icon_active = not is_new_icon_active  # Alterna el estado

func _show_lista_sitios():
	# Inicializar el Tween y configurar la animación para mostrar
	var tween = TweenManager.init_tween(_on_finish_tween)
	TweenManager.tween_animacion(tween, sitio_detalles, "custom_minimum_size:y", 200, 0.5)  # 200 tamaño original
	sitio_detalles.visible = true
	is_hidden = false

func _hide_lista_sitios():
	# Inicializar el Tween y configurar la animación para esconder
	var tween = TweenManager.init_tween(_on_finish_tween)
	TweenManager.tween_animacion(tween, sitio_detalles, "custom_minimum_size:y", 0, 0.5)
	is_hidden = true

func _on_finish_tween():
	if is_hidden:
		sitio_detalles.visible = false

func _on_btn_home_pressed():
	ui_particular.visible = false

func _compare_and_print_selected_site(parametro):
	var last_selected_id = NavigationManager.last_selected
	for sitio in datos_sitios:
		if sitio.id_estacion == last_selected_id:
			#print_site_details(sitio)
			set_datos_particular(sitio)
			return  # Sale de la función una vez encontrado el sitio

func print_site_details(sitio: Estacion):
	print("ID Estación: ", sitio.id_estacion)
	print("Nombre: ", sitio.nombre)
	print("Enlace: ", sitio.enlace)
	print("Fecha: ", sitio.tiempo)
	print("Señales: ")
	for _signal in sitio.signals:
		if _signal is Señal:
			print("\tSeñal: ", _signal.nombre)
			print("\tValor: ", _signal.valor)

	
func set_datos_particular(sitio: Estacion):
	lbl_header_nombre.text = sitio.nombre
	# Cambiar textura según el valor de sitio.enlace
	if sitio.enlace in [1, 2, 3]:
		texture_enlace.texture = texture_online
	elif sitio.enlace == 0:
		texture_enlace.texture = texture_offline

	# Asignar el nombre de la señal a lbl_presion si tipo_signal es 2,3
	for _signal in sitio.signals.values():
		# Obtener la unidad correspondiente al tipo de señal
		var unidad = unidades.get(_signal.tipo_signal, "")
		
		if _signal is Señal and _signal.tipo_signal == 1:
			set_progress_bar(_signal, unidad)
		if _signal is Señal and _signal.tipo_signal == 2:
			lbl_presion.text = _signal.nombre
			lbl_presion_valor.text = str(_signal.valor) + " " + unidad
		if  _signal is Señal and _signal.tipo_signal == 3:
			lbl_gasto.text = _signal.nombre
			lbl_gasto_valor.text = str(_signal.valor) + " " + unidad
			break
			
	lbl_fecha.text = GlobalUtils.formatear_fecha(sitio.tiempo)
	
func set_progress_bar(_signal: Señal, unidad):
	progress_bar.min_value = 0.5
	progress_bar.max_value = _signal.semaforo["critico"]
	lbl_valor.text = str(_signal.valor) + " " + unidad
	
	# Asegurarse de que el valor mínimo visible siempre esté presente
	var display_value = max(_signal.valor, _signal.semaforo["normal"])
	if _signal.valor < 1.0 :
		display_value = remap(_signal.valor,  0.0,  _signal.semaforo["normal"], 0.67, 1.15)
	else :
		display_value = remap(_signal.valor,  _signal.semaforo["normal"],  _signal.semaforo["critico"], 1.15, 2.7 )	

	#progress_bar.value = display_value
	lbl_progress_bar_valor_min.text = str(_signal.semaforo["normal"]) + " " + unidad
	lbl_progress_bar_valor_max.text = str(_signal.semaforo["critico"]) + " " + unidad
	lbl_nivel_nombre.text = _signal.nombre

	# Cambiar el color de la barra de progreso según el valor de la señal
	if _signal.valor > _signal.semaforo.normal and _signal.valor <= _signal.semaforo.preventivo:
		progress_bar.modulate = Color(1, 1, 0) # Amarillo
	elif _signal.valor > _signal.semaforo.preventivo:
		progress_bar.modulate = Color(1, 0, 0) # Rojo
	else:
		progress_bar.modulate = Color(0, 1, 0) # Verde
	
	# Usar Tween para animar la barra de progreso	
	var tween = create_tween()
	tween.tween_property(progress_bar, "value", display_value, 1)

func init_particular(is_particular):
	if is_particular == true:
		fondo_render_material.set("shader_parameter/progress",0)
		var tweenFlipbook = TweenManager.init_tween(On_FlipbookAnimationEnded)
		tweenFlipbook.tween_property( fondo_render_material,"shader_parameter/progress",29,.85)

func On_FlipbookAnimationEnded():
	pass		

