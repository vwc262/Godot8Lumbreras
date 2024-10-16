extends Control

@onready var sub_viewport_container: SubViewportContainer = $VBoxContainer/main_container/modelo_3d_container/SubViewportContainer
@onready var background_flip_book: ColorRect = $VBoxContainer/main_container/modelo_3d_container/BackgroundFlipBook2

@onready var btn_lista = $VBoxContainer/main_container/detalles_container/VBoxContainer/botones_container/HBoxContainer/btn_lista
@onready var sitio_detalles = $VBoxContainer/main_container/detalles_container/VBoxContainer/sitio_detalles
@onready var ui_particular = $"."

@onready var datos_sitios: Array[Estacion] = GlobalData.get_data()

@onready var lbl_header_nombre = $VBoxContainer/header_container/HBoxContainer/header_nombre_container/lbl_header_nombre
@onready var btn_graficador_lbl = $VBoxContainer/main_container/detalles_container/VBoxContainer/botones_container/HBoxContainer/btn_graficador/Label

@onready var lbl_presion = $VBoxContainer/main_container/detalles_container/VBoxContainer/sitio_detalles/VBoxContainer/HBoxContainer/Panel/HBoxContainer/Presion_container/HBoxContainer/Panel2/lbl_presion
@onready var lbl_presion_valor = $VBoxContainer/main_container/detalles_container/VBoxContainer/sitio_detalles/VBoxContainer/HBoxContainer/Panel/HBoxContainer/Presion_container/HBoxContainer/Panel/lbl_presion_valor
@onready var lbl_gasto = $"VBoxContainer/main_container/detalles_container/VBoxContainer/sitio_detalles/VBoxContainer/HBoxContainer/Panel/HBoxContainer/Gasto_container/HBoxContainer/Panel2/lbl_gasto"
@onready var lbl_gasto_valor = $"VBoxContainer/main_container/detalles_container/VBoxContainer/sitio_detalles/VBoxContainer/HBoxContainer/Panel/HBoxContainer/Gasto_container/HBoxContainer/Panel/lbl_gasto_valor"
@onready var lbl_fecha: Label = $VBoxContainer/main_container/detalles_container/VBoxContainer/sitio_detalles/VBoxContainer/fecha_container/PanelContainer/lbl_fecha

@onready var progress_bar = $VBoxContainer/main_container/progress_bar_container/ProgressBar
@onready var lbl_progress_bar_valor_min = $VBoxContainer/main_container/progress_bar_container/progress_bar_marcadores_container/min_container/lbl_progress_bar_valor_min
@onready var lbl_progress_bar_valor_max = $VBoxContainer/main_container/progress_bar_container/progress_bar_marcadores_container/max_container/lbl_progress_bar_valor_max
@onready var lbl_nivel_nombre = $VBoxContainer/main_container/progress_bar_container/lbl_nivel_nombre
@onready var lbl_valor = $VBoxContainer/main_container/progress_bar_container/ProgressBar/lbl_valor

@onready var v_box_container = $VBoxContainer/main_container/lista_sitios_container/ScrollContainer/VBoxContainer
@onready var lista_sitios_container = $VBoxContainer/main_container/lista_sitios_container

@onready var modelo_3d_container = $VBoxContainer/main_container/modelo_3d_container
@onready var datos_sitio = $VBoxContainer/main_container/detalles_container/VBoxContainer/sitio_detalles/VBoxContainer

@onready var lista_sitio_scene = preload("res://Scenes/UI/UI_Particular_Sitio_lista.tscn")
#@export var lista_sitio_scene : PackedScene 
@onready var fondo_sitio_: TextureRect = $VBoxContainer/main_container/modelo_3d_container/fondo_sitio_

#region
@onready var header_fondo: TextureRect = $VBoxContainer/header_container/header_fondo
@onready var enlace_fondo: TextureRect = $VBoxContainer/header_container/HBoxContainer/header_icono_container/enlace_fondo
@onready var texture_enlace: TextureRect = $VBoxContainer/header_container/HBoxContainer/header_icono_container/texture_enlace
@onready var progress_bar_fondo: TextureRect = $VBoxContainer/main_container/progress_bar_container/progress_bar_fondo
@onready var progress_bar_cubierta_inicio: TextureRect = $VBoxContainer/main_container/progress_bar_container/progress_bar_cubierta_inicio
@onready var progress_bar_marcadores: TextureRect = $VBoxContainer/main_container/progress_bar_container/progress_bar_marcadores_container/progress_bar_marcadores
@onready var detalles_fondo: TextureRect = $VBoxContainer/main_container/detalles_container/VBoxContainer/sitio_detalles/detalles_fondo
@onready var punto_1: TextureRect = $VBoxContainer/main_container/detalles_container/VBoxContainer/sitio_detalles/VBoxContainer/HBoxContainer/Panel/HBoxContainer/Presion_container/HBoxContainer/punto_1
@onready var punto_2: TextureRect = $VBoxContainer/main_container/detalles_container/VBoxContainer/sitio_detalles/VBoxContainer/HBoxContainer/Panel/HBoxContainer/Gasto_container/HBoxContainer/punto_2
@onready var btn_icono_izq: TextureRect = $VBoxContainer/main_container/detalles_container/VBoxContainer/botones_container/HBoxContainer/btn_graficador/btn_icono_izq
@onready var btn_icono_mid: TextureRect = $VBoxContainer/main_container/detalles_container/VBoxContainer/botones_container/HBoxContainer/btn_lista/btn_icono_mid
@onready var btn_icono_der: TextureRect = $VBoxContainer/main_container/detalles_container/VBoxContainer/botones_container/HBoxContainer/btn_home/btn_icono_der
@onready var btn_lista_icono: TextureRect = $VBoxContainer/header_container/HBoxContainer/header_btn_container/header_btn_lista_sitios/btn_lista_icono
@onready var fecha_fondo: TextureRect = $VBoxContainer/main_container/detalles_container/VBoxContainer/sitio_detalles/VBoxContainer/fecha_container/PanelContainer/fecha_fondo
@onready var gasto_fondo: TextureRect = $VBoxContainer/main_container/detalles_container/VBoxContainer/sitio_detalles/VBoxContainer/HBoxContainer/Panel/HBoxContainer/Gasto_container/HBoxContainer/Panel/gasto_fondo
@onready var presion_fondo: TextureRect = $VBoxContainer/main_container/detalles_container/VBoxContainer/sitio_detalles/VBoxContainer/HBoxContainer/Panel/HBoxContainer/Presion_container/HBoxContainer/Panel/presion_fondo
@onready var original_icon: Texture
@onready var new_icon: Texture
@onready var flecha_lista_sitio_open: Texture
@onready var flecha_lista_sitio_close: Texture
@onready var texture_online: Texture
@onready var texture_offline: Texture
@onready var lista_sitio_fondo_1: Texture
@onready var lista_sitio_fondo_2: Texture

var fondos_sitios_temporales: Dictionary = {
	1: "res://Recursos/UI/img/cutzamala_v_final/sitios_temporales/pb1.PNG",
	2: "res://Recursos/UI/img/cutzamala_v_final/sitios_temporales/pb2.PNG",
	3: "res://Recursos/UI/img/cutzamala_v_final/sitios_temporales/pb3.PNG",
	4: "res://Recursos/UI/img/cutzamala_v_final/sitios_temporales/pb4.PNG",
	6: "res://Recursos/UI/img/cutzamala_v_final/sitios_temporales/PB6.PNG",
}
#endregion

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
	3: "m³/s"
}

func set_fondos_temporales(id_sitio):
	if fondos_sitios_temporales.has(id_sitio):
		fondo_sitio_.texture = load(fondos_sitios_temporales[id_sitio]) 
	fondo_sitio_.visible = true if id_sitio != 5 else false

func set_textures():
	var _GlobalTextureResource = GlobalTextureResource.get_curret_resource()
	original_icon = _GlobalTextureResource.get_texture("boton_hide_lista")
	new_icon = _GlobalTextureResource.get_texture("boton_show_lista")
	header_fondo.texture = _GlobalTextureResource.get_texture("header")
	btn_lista_icono.texture = _GlobalTextureResource.get_texture("header_icono_lista")
	enlace_fondo.texture = _GlobalTextureResource.get_texture("header_contenedor_estado")
	texture_enlace.texture = _GlobalTextureResource.get_texture("header_estado_online")
	progress_bar_fondo.texture = _GlobalTextureResource.get_texture("progressbar_base")
	progress_bar_cubierta_inicio.texture = _GlobalTextureResource.get_texture("progressbar_cubierta")
	progress_bar_marcadores.texture = _GlobalTextureResource.get_texture("progressbar_max_min")
	detalles_fondo.texture = _GlobalTextureResource.get_texture("detalles_fondo")
	punto_1.texture = _GlobalTextureResource.get_texture("punto_listas")
	punto_2.texture = _GlobalTextureResource.get_texture("punto_listas")
	btn_icono_izq.texture = _GlobalTextureResource.get_texture("boton_cambio_scene_izq")
	btn_icono_der.texture = _GlobalTextureResource.get_texture("boton_cambio_scene_der")
	btn_icono_mid.texture = _GlobalTextureResource.get_texture("boton_hide_lista")
	flecha_lista_sitio_open = _GlobalTextureResource.get_texture("header_lista_icono")
	flecha_lista_sitio_close = _GlobalTextureResource.get_texture("header_icono_lista")
	texture_online = _GlobalTextureResource.get_texture("header_estado_online")
	texture_offline = _GlobalTextureResource.get_texture("header_estado_offline")
	lista_sitio_fondo_1 = _GlobalTextureResource.get_texture("header_lista_a")
	lista_sitio_fondo_2 = _GlobalTextureResource.get_texture("header_lista_b")
	fecha_fondo.texture = _GlobalTextureResource.get_texture("lista_valor_contenedor")
	gasto_fondo.texture = _GlobalTextureResource.get_texture("lista_valor_contenedor")
	presion_fondo.texture = _GlobalTextureResource.get_texture("lista_valor_contenedor")

# Función _ready para inicializar los nodos y conectar señales
func _ready():
	set_textures()
	UIManager.fondo_sitio_temporal = fondo_sitio_
	SceneManager.add_subviewport_reference(SceneManager.TIPO_NIVEL.PARTICULAR,sub_viewport_container)
	UIManager.modelo3D_container = modelo_3d_container
	UIManager.datos_sitio =  datos_sitio
	UIManager.btn_graficador = btn_graficador_lbl
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
		btn_icono_mid.texture = original_icon
		_show_lista_sitios()
	else:
		btn_icono_mid.texture = new_icon
		_hide_lista_sitios()
	is_new_icon_active = not is_new_icon_active  # Alterna el estado

# Función para mostrar la lista de sitios
func _show_lista_sitios():
	var tween = TweenManager.init_tween(_on_finish_tween)
	TweenManager.tween_animacion(tween, sitio_detalles, "custom_minimum_size:y", 200, 0.3)
	sitio_detalles.visible = true
	is_hidden = false

# Función para ocultar la lista de sitios
func _hide_lista_sitios():
	var tween = TweenManager.init_tween(_on_finish_tween)
	TweenManager.tween_animacion(tween, sitio_detalles, "custom_minimum_size:y", 0, 0.3)
	is_hidden = true

# Función que se llama cuando termina el tween
func _on_finish_tween():
	if is_hidden:
		sitio_detalles.visible = false

# Función que maneja el botón de inicio
func _on_btn_home_pressed():
	NavigationManager.emit_signal('ResetCameraPosition')
	UIManager.deselect_all_sitios()
	#UIManager.ocultar_particular()
	SceneManager.scroll_scene(SceneManager.TIPO_NIVEL.PERFIL,SceneManager.idScenePerfil)	

func reprint():
	_compare_and_print_selected_site(0)
	_on_header_btn_lista_sitios_pressed()

# Función que compara y actualiza el sitio seleccionado
func _compare_and_print_selected_site(_parametro):
	var last_selected_id = NavigationManager.last_selected
	for sitio in datos_sitios:
		if sitio.id_estacion == last_selected_id:
			set_datos_particular(sitio)
			return  # Sale de la función una vez encontrado el sitio

# Función para establecer los datos del sitio seleccionado
func set_datos_particular(sitio: Estacion):
	lbl_header_nombre.text = sitio.nombre
	texture_enlace.texture = texture_online if sitio.is_estacion_en_linea() else texture_offline

	for _signal in sitio.signals.values():
		var unidad = _signal.get_unities()
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
	lbl_nivel_nombre.text = _signal.nombre
	#progress_bar.value = display_value
	lbl_progress_bar_valor_min.text = str(_signal.semaforo["normal"]) + " " + unidad
	lbl_progress_bar_valor_max.text = str(_signal.semaforo["critico"]) + " " + unidad
	if _signal.is_dentro_rango():
		lbl_valor.text = str(_signal.valor) + " " + unidad
	
		#Asegurarse de que el valor mínimo visible siempre esté presente
		var display_value = max(_signal.valor, _signal.semaforo["normal"])
		if _signal.valor < 1.0:
			display_value = remap(_signal.valor, 0.0, _signal.semaforo["normal"], 0.67, 1.15)
		else:
			display_value = remap(_signal.valor, _signal.semaforo["normal"], _signal.semaforo["critico"], 1.15, 2.7)

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
	
	else: 
		lbl_valor.text = "N.D." 
		progress_bar.value = progress_bar.max_value
		progress_bar.modulate = Color(0.7, 0.7, 0.7,1.0)


# Función para inicializar los parámetros particulares
func init_particular(is_particular):
	if is_particular:
		_on_datos_actualizados(GlobalData.get_data())

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
		btn_lista_icono.texture = flecha_lista_sitio_open
		_show_lista()
	else:
		btn_lista_icono.texture = flecha_lista_sitio_close
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

# Funcion para mostrar/ocultar el graficador
func _on_btn_graficador_pressed():
	SceneManager.scroll_scene(SceneManager.TIPO_NIVEL.GRAFICADOR,200)

func _on_sub_viewport_container_visibility_changed() -> void:
	background_flip_book.visible = true if !sub_viewport_container.visible else false
