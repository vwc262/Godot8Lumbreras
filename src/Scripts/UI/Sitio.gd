extends Node

@export var signal_scene: PackedScene

@onready var texture_estado_enlace = $VBoxContainer/datos_sitio_container/HBoxContainer/estado_enlace
@onready var lbl_nombre_sitio = $VBoxContainer/datos_sitio_container/HBoxContainer/nombre_fecha_contaier/HBoxContainer/nombre_sitio
@onready var lbl_fecha_sitio = $VBoxContainer/datos_sitio_container/HBoxContainer/nombre_fecha_contaier/HBoxContainer/fecha_sitio
@onready var se_ales_sitios = $"VBoxContainer/PanelContainer/Control/señales_sitios"
@onready var panel_container = $VBoxContainer/PanelContainer
@onready var btn_expandir_sitios = $VBoxContainer/datos_sitio_container/HBoxContainer/BTN_expandir_sitios
@onready var button = $VBoxContainer/datos_sitio_container/HBoxContainer/nombre_fecha_contaier/Button
@onready var sitio: PanelContainer = $"."

#region
@onready var sitio_fondo: TextureRect = $VBoxContainer/datos_sitio_container/sitio_fondo #SE ASIGNA SU TEXTURA EN LISTA SITIO
@onready var estado_enlace: TextureRect = $VBoxContainer/datos_sitio_container/HBoxContainer/estado_enlace
@onready var sitio_fondo_seleccionado: TextureRect = $VBoxContainer/datos_sitio_container/sitio_fondo_seleccionado
@onready var btn_expandir_fondo: TextureRect = $VBoxContainer/datos_sitio_container/HBoxContainer/BTN_expandir_sitios/btn_expandir_fondo
@onready var texture_hidden: Texture   # Textura cuando está oculto
@onready var texture_visible: Texture  # Textura cuando está visible
@onready var estado_online: Texture
@onready var estado_offline: Texture
#endregion

var estacion_ref: Estacion
var signal_ref = {}
var signal_instances: Array = []
var id_estacion: int

var is_hidden = true
var is_double_click_disabled = false

var is_signals_instantiated = false
var my_index = 0



func set_textures():
	var _GlobalTextureResource = GlobalTextureResource.get_curret_resource()
	texture_hidden = _GlobalTextureResource.get_texture("boton_flecha_close")
	texture_visible = _GlobalTextureResource.get_texture("boton_flecha_open")
	estado_online = _GlobalTextureResource.get_texture("icono_online")
	estado_offline = _GlobalTextureResource.get_texture("icono_offline")
	sitio_fondo_seleccionado.texture = _GlobalTextureResource.get_texture("sitio_seleccionado")
	

func _ready():
	set_textures()
	NavigationManager.connect("OnTweenFinished_MovimientoRealizado", _on_camera_zoom)	
	
# Función para recibir y establecer los datos de la estación
func set_datos(estacion: Estacion,index:int):
	my_index = index
	estacion_ref = estacion
	id_estacion = estacion_ref.id_estacion
	UIManager.add_sitio(self)
	signal_ref = estacion_ref.signals
	call_deferred("actualizar_datos")
	call_deferred("set_enlace")
	if !is_signals_instantiated:
		call_deferred("instanciar_señales")
	else:
		call_deferred("update_signals")

# Función para actualizar los datos mostrados
func actualizar_datos():
	lbl_nombre_sitio.text = estacion_ref.nombre
	# Usar la función global para formatear la fecha
	lbl_fecha_sitio.text = GlobalUtils.formatear_fecha(estacion_ref.tiempo)

# Función para actualizar el estado del enlace
func set_enlace():
	if estacion_ref.is_estacion_en_linea():
		texture_estado_enlace.texture = estado_online
	else:
		texture_estado_enlace.texture = estado_offline

# Función para instanciar y actualizar señales
func instanciar_señales():
	# Limpiar las instancias actuales de señales
	for signal_instance in signal_instances:
		signal_instance.queue_free()
	signal_instances.clear()

	# Instanciar y agregar una sola señal
	var signal_instance = signal_scene.instantiate()
	se_ales_sitios.add_child(signal_instance)
	signal_instance.set_datos(estacion_ref)  # Pasar la referencia de todas las señales
	signal_instances.append(signal_instance)

	# Ocultar el panel de señales si no hay señales
	panel_container.visible = signal_ref.size() > 0
	
	is_signals_instantiated = true
	
func update_signals():
	for instance_singal in se_ales_sitios.get_children():
		instance_singal.set_datos(estacion_ref)
	
# Función que maneja la señal del botón presionado
func _on_button_pressed():
	# Deshabilitar el botón mientras se ejecuta el tween
	button.disabled = true
	
	NavigationManager.emit_signal("Go_TO", estacion_ref.id_estacion)
	# Usar UIManager para manejar la selección del sitio
	UIManager.seleccionar_sitio(self)

# Función para seleccionar el sitio
func seleccionar():
	sitio_fondo_seleccionado.visible = true

# Función para deseleccionar el sitio
func deseleccionar():
	sitio_fondo_seleccionado.visible = false

func _on_btn_expandir_sitios_pressed():
	btn_expandir_sitios.disabled = true

	if is_hidden:
		_show_lista_señales()
		#follow_focus()
	else:
		_hide_lista_señales()

func _show_lista_señales():
	var tween = TweenManager.init_tween(_on_finish_tween)
	TweenManager.tween_animacion(tween, panel_container, "custom_minimum_size:y", 180, 0.2)
	panel_container.visible = true
	is_hidden = false
	btn_expandir_fondo.texture = texture_visible

func _hide_lista_señales():
	var tween = TweenManager.init_tween(_on_finish_tween)
	TweenManager.tween_animacion(tween, panel_container, "custom_minimum_size:y", 0, 0.2)
	is_hidden = true
	btn_expandir_fondo.texture = texture_hidden

func _on_finish_tween():
	btn_expandir_sitios.disabled = false
	if is_hidden:
		panel_container.visible = false
	else:
		follow_focus()
	
func get_offset(index_to_go:int)-> float:
	var current_index = 0
	var offset = 0
	for hijo in UIManager.vb_scroll.get_children():
		if current_index < index_to_go:
			offset += 110 if hijo.is_hidden else 290
			current_index += 1	
		else: 
			break
	return offset

func follow_focus():	
	const step = 0 
	var to_move = get_offset(my_index)
	# Obtener la posición que se necesita para que el sitio esté visible
	# Calcular la posición final del scroll
	var tween: Tween = TweenManager.init_tween(_on_finish_tween_focus)	
	TweenManager.tween_animacion(tween,UIManager.scroll_container.get_v_scroll_bar(), "value", to_move , 0.2)

func _on_finish_tween_focus(): pass

func set_fondo(texture: Texture):
	# Actualizar la textura del fondo
	sitio_fondo.texture = texture

# Función llamada cuando el tween de la cámara ha terminado
func _on_camera_zoom():
	# Rehabilitar el botón una vez que el tween de la cámara ha terminado
	button.disabled = false
