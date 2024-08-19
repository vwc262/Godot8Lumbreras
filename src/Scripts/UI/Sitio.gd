extends Node

@export var signal_scene: PackedScene
@export var texture_visible: Texture  # Textura cuando está visible
@export var texture_hidden: Texture   # Textura cuando está oculto

@onready var texture_estado_enlace = $VBoxContainer/datos_sitio_container/HBoxContainer/estado_enlace
@onready var lbl_nombre_sitio = $VBoxContainer/datos_sitio_container/HBoxContainer/nombre_fecha_contaier/HBoxContainer/nombre_sitio
@onready var lbl_fecha_sitio = $VBoxContainer/datos_sitio_container/HBoxContainer/nombre_fecha_contaier/HBoxContainer/fecha_sitio
@onready var se_ales_sitios = $"VBoxContainer/PanelContainer/Control/señales_sitios"
@onready var panel_container = $VBoxContainer/PanelContainer
@onready var btn_expandir_sitios = $VBoxContainer/datos_sitio_container/HBoxContainer/BTN_expandir_sitios
@onready var btn_expandir_fondo = $VBoxContainer/datos_sitio_container/HBoxContainer/BTN_expandir_sitios/btn_expandir_fondo
@onready var sitio_fondo = $VBoxContainer/datos_sitio_container/sitio_fondo
@onready var sitio_fondo_seleccionado = $VBoxContainer/datos_sitio_container/sitio_fondo_seleccionado
@onready var button = $VBoxContainer/datos_sitio_container/HBoxContainer/nombre_fecha_contaier/Button
@onready var sitio: PanelContainer = $"."

var estacion_ref: Estacion
var signal_ref = {}
var signal_instances: Array = []
var id_estacion: int

var is_hidden = true
var is_double_click_disabled = false

var is_signals_instantiated = false

func _ready():
	NavigationManager.connect("OnTweenFinished_MovimientoRealizado", _on_camera_zoom)
	
	
# Función para recibir y establecer los datos de la estación
func set_datos(estacion: Estacion):
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
	texture_estado_enlace.texture = preload("res://Recursos/UI/img/CutzamalaMovil_Perfil_V3/EncabezadoB_base_Conexion_a.png") if estacion_ref.is_estacion_en_linea() else preload("res://Recursos/UI/img/CutzamalaMovil_Perfil_V3/EncabezadoB_base_Conexion_b.png")	

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

# Función que maneja el botón de expandir/esconder
func _on_btn_expandir_sitios_pressed():
	btn_expandir_sitios.disabled = true
	if is_hidden:
		# Mostrar el contenedor
		_show_lista_señales()
	else:
		# Esconder el contenedor
		_hide_lista_señales()

# Función para mostrar la lista de señales
func _show_lista_señales():
	# Inicializar el Tween y configurar la animación para mostrar
	var tween = TweenManager.init_tween(_on_finish_tween)
	TweenManager.tween_animacion(tween, panel_container, "custom_minimum_size:y", 360, 0.2)  # 160 tamaño original
	panel_container.visible = true
	is_hidden = false
	# Cambiar la textura al estado visible
	btn_expandir_fondo.texture = texture_visible

# Función para esconder la lista de señales
func _hide_lista_señales():
	# Inicializar el Tween y configurar la animación para esconder
	var tween = TweenManager.init_tween(_on_finish_tween)
	TweenManager.tween_animacion(tween, panel_container, "custom_minimum_size:y", 0, 0.2)
	is_hidden = true
	# Cambiar la textura al estado oculto
	btn_expandir_fondo.texture = texture_hidden

# Función llamada al terminar la animación del Tween
func _on_finish_tween():
	btn_expandir_sitios.disabled = false
	# Confirmación de que el tween ha terminado
	if is_hidden:
		panel_container.visible = false

func set_fondo(texture: Texture):
	# Actualizar la textura del fondo
	sitio_fondo.texture = texture

# Función llamada cuando el tween de la cámara ha terminado
func _on_camera_zoom():
	# Rehabilitar el botón una vez que el tween de la cámara ha terminado
	button.disabled = false
