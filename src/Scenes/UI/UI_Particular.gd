extends Control

@onready var btn_lista = $VBoxContainer/main_container/detalles_container/VBoxContainer/botones_container/HBoxContainer/btn_lista
@onready var sitio_detalles = $VBoxContainer/main_container/detalles_container/VBoxContainer/sitio_detalles
@onready var ui_particular = $"."

@onready var datos_sitios: Array[Estacion] = GlobalData.get_data()

@onready var lbl_header_nombre = $VBoxContainer/header_container/HBoxContainer/header_nombre_container/lbl_header_nombre
@onready var fondo_render_material : Material = $VBoxContainer/main_container/fondo_render.material
@onready var fondo_render_final = $VBoxContainer/main_container/fondo_render_final
@onready var fondo_render = $VBoxContainer/main_container/fondo_render

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

@onready var v_box_container = $VBoxContainer/main_container/lista_sitios_container/ScrollContainer/VBoxContainer
@onready var lista_sitios_container = $VBoxContainer/main_container/lista_sitios_container
@onready var header_btn_lista_sitios = $VBoxContainer/header_container/HBoxContainer/header_btn_container/header_btn_lista_sitios

@export var new_icon: Texture2D
@export var texture_online: Texture2D
@export var texture_offline: Texture2D
@export var lista_sitio_fondo_1: Texture2D
@export var lista_sitio_fondo_2: Texture2D
@export var flecha_lista_sitio_open: Texture2D
@export var flecha_lista_sitio_close: Texture2D
@export var lista_sitio_scene: PackedScene

var original_icon: Texture2D
var is_new_icon_active: bool = false
var is_lista_icon_active: bool = true
var is_hidden: bool = false
var is_list_hidden: bool = true
var site_instances = {}  # Diccionario para mantener instancias de las estaciones
var use_fondo_1 = true  # Variable para alternar entre los fondos


# Diccionario para las unidades de tipo de señal
var unidades = {
	1: "m",
	2: "kg/cm²",
	3: "l/s"
}

# Función _ready para inicializar los nodos y conectar señales
func _ready():
	original_icon = btn_lista.icon  # Guarda el ícono original
	btn_lista.connect("pressed", _on_btn_lista_pressed)
	NavigationManager.connect("Go_TO", _compare_and_print_selected_site)
	GlobalData.connect("datos_actualizados", _on_datos_actualizados)
	instanciar_lista_sitios()  # Llama a la función para instanciar los sitios

# Función que se llama cuando se actualizan los datos
func _on_datos_actualizados(estaciones: Array[Estacion]):
	datos_sitios = estaciones  # Actualiza los datos locales
	_compare_and_print_selected_site(estaciones)
	instanciar_lista_sitios()  # Reinstancia los sitios con los nuevos datos

# Función que maneja el botón de la lista de sitios
func _on_btn_lista_pressed():
	if is_new_icon_active:
		btn_lista.icon = original_icon
		_show_lista_sitios()
	else:
		btn_lista.icon = new_icon
		_hide_lista_sitios()
	is_new_icon_active = not is_new_icon_active  # Alterna el estado

# Función para mostrar la lista de sitios
func _show_lista_sitios():
	var tween = TweenManager.init_tween(_on_finish_tween)
	TweenManager.tween_animacion(tween, sitio_detalles, "custom_minimum_size:y", 200, 0.5)
	sitio_detalles.visible = true
	is_hidden = false

# Función para ocultar la lista de sitios
func _hide_lista_sitios():
	var tween = TweenManager.init_tween(_on_finish_tween)
	TweenManager.tween_animacion(tween, sitio_detalles, "custom_minimum_size:y", 0, 0.5)
	is_hidden = true

# Función que se llama cuando termina el tween
func _on_finish_tween():
	if is_hidden:
		sitio_detalles.visible = false

# Función que maneja el botón de inicio
func _on_btn_home_pressed():
	UIManager.ocultar_particular()	
	SceneManager.load_scene(SceneManager.idScenePerfil)
	
func reprint():
	_compare_and_print_selected_site(0)
	_on_header_btn_lista_sitios_pressed()
	
# Función que compara y actualiza el sitio seleccionado
func _compare_and_print_selected_site(parametro):
	var last_selected_id = NavigationManager.last_selected
	for sitio in datos_sitios:
		if sitio.id_estacion == last_selected_id:
			set_datos_particular(sitio)
			return  # Sale de la función una vez encontrado el sitio

# Función para establecer los datos del sitio seleccionado
func set_datos_particular(sitio: Estacion):
	lbl_header_nombre.text = sitio.nombre
	
	if sitio.enlace in [1, 2, 3]:
		texture_enlace.texture = texture_online
	else:
		texture_enlace.texture = texture_offline

	for _signal in sitio.signals.values():
		var unidad = unidades.get(_signal.tipo_signal, "")
		if _signal is Señal:
			if _signal.tipo_signal == 1:
				set_progress_bar(_signal, unidad)
			elif _signal.tipo_signal == 2:
				lbl_presion.text = _signal.nombre
				lbl_presion_valor.text = str(_signal.valor) + " " + unidad
			elif _signal.tipo_signal == 3:
				lbl_gasto.text = _signal.nombre
				lbl_gasto_valor.text = str(_signal.valor) + " " + unidad
				break
	lbl_fecha.text = GlobalUtils.formatear_fecha(sitio.tiempo)

# Función para establecer la barra de progreso
func set_progress_bar(_signal: Señal, unidad):
	progress_bar.min_value = 0.5
	progress_bar.max_value = _signal.semaforo["critico"]
	lbl_valor.text = str(_signal.valor) + " " + unidad

	#Asegurarse de que el valor mínimo visible siempre esté presente
	var display_value = max(_signal.valor, _signal.semaforo["normal"])
	if _signal.valor < 1.0:
		display_value = remap(_signal.valor, 0.0, _signal.semaforo["normal"], 0.67, 1.15)
	else:
		display_value = remap(_signal.valor, _signal.semaforo["normal"], _signal.semaforo["critico"], 1.15, 2.7)

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

	#Usar Tween para animar la barra de progreso
	var tween = create_tween()
	tween.tween_property(progress_bar, "value", display_value, 1)

# Función para inicializar los parámetros particulares
func init_particular(is_particular):
	if is_particular:
		fondo_render_final.visible = false
		fondo_render.visible = true
		fondo_render_material.set("shader_parameter/progress", 0)
		var tweenFlipbook = TweenManager.init_tween(On_FlipbookAnimationEnded)
		tweenFlipbook.tween_property(fondo_render_material, "shader_parameter/progress", 29, 1.6)

# Función que se llama al terminar la animación del flipbook
func On_FlipbookAnimationEnded():
	fondo_render_final.visible = true
	fondo_render.visible = false

# Función para instanciar escenas de la lista de sitios
func instanciar_lista_sitios():
	for sitio in datos_sitios:
		if sitio.id_estacion in site_instances:
			site_instances[sitio.id_estacion].set_datos(sitio)  # Actualizar datos si ya existe la instancia
		else:
			var lista_sitio_instance = lista_sitio_scene.instantiate()
			v_box_container.add_child(lista_sitio_instance)
			lista_sitio_instance.set_datos(sitio)
			
			# Alternar entre los fondos
			if use_fondo_1:
				lista_sitio_instance.set_fondo(lista_sitio_fondo_1)
			else:
				lista_sitio_instance.set_fondo(lista_sitio_fondo_2)
			use_fondo_1 = not use_fondo_1  # Alternar el valor
			
			site_instances[sitio.id_estacion] = lista_sitio_instance  # Guardar la instancia en el diccionario


# Función que maneja el botón de la lista de sitios en el encabezado
func _on_header_btn_lista_sitios_pressed():
	if is_lista_icon_active:
		header_btn_lista_sitios.icon = flecha_lista_sitio_open
		_show_lista()
	else:
		header_btn_lista_sitios.icon = flecha_lista_sitio_close
		_hide_lista()
	is_lista_icon_active = not is_lista_icon_active  # Alterna el estado

# Función para mostrar la lista de sitios
func _show_lista():
	var tween = TweenManager.init_tween(_on_finish_tween_sitios)
	TweenManager.tween_animacion(tween, lista_sitios_container, "custom_minimum_size:y", 650, 0.3)
	lista_sitios_container.visible = true
	is_list_hidden = false

# Función para ocultar la lista de sitios
func _hide_lista():
	var tween = TweenManager.init_tween(_on_finish_tween_sitios)
	TweenManager.tween_animacion(tween, lista_sitios_container, "custom_minimum_size:y", 0, 0.3)
	is_list_hidden = true

# Función que se llama al terminar la animación de mostrar/ocultar la lista de sitios
func _on_finish_tween_sitios():
	if is_list_hidden:
		lista_sitios_container.visible = false
