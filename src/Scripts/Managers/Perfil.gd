extends Node
#region Editor variables
@onready var scroll_container: ScrollContainer = $ScrollContainer
@onready var btn_lista_sitios: Button = $ScrollContainer/WindowsContainer/PerfilWindow/VB_MainContainer/Panel/main_container/ListaSitiosContainer/VBoxContainer/botones_container/HBoxContainer/BTN_ListaSitios

@onready var lista_sitios: Control = $ScrollContainer/WindowsContainer/PerfilWindow/VB_MainContainer/Panel/main_container/ListaSitiosContainer/VBoxContainer/PanelContainer/ListaSitios
@onready var header_fondo: TextureRect = $ScrollContainer/WindowsContainer/PerfilWindow/VB_MainContainer/header_container/header_fondo
@onready var perfil: Node3D = $ScrollContainer/WindowsContainer/PerfilWindow/VB_MainContainer/Panel/main_container/VBoxContainer/SubViewportContainer/SubViewport/Perfil

@export var perfil_world_environment : Environment
@export var particular_world_environment : Environment
@onready var windows_container: HBoxContainer = $ScrollContainer/WindowsContainer
@onready var ui_particular: Control = $ScrollContainer/WindowsContainer/ParticularWindow/UiParticular
@onready var sub_viewport_container: SubViewportContainer = $ScrollContainer/WindowsContainer/PerfilWindow/VB_MainContainer/Panel/main_container/VBoxContainer/SubViewportContainer
@onready var background_flip_book: ColorRect = $ScrollContainer/WindowsContainer/PerfilWindow/VB_MainContainer/Panel/main_container/VBoxContainer/BackgroundFlipBook
@onready var lbl_online_contador = $ScrollContainer/WindowsContainer/PerfilWindow/VB_MainContainer/header_container/contador_contaier/HBoxContainer/online_container/lbl_online_contador
@onready var lbl_offline_contador = $ScrollContainer/WindowsContainer/PerfilWindow/VB_MainContainer/header_container/contador_contaier/HBoxContainer/offline_container/lbl_offline_contador

#endregion

@onready var ui_paleta: Control = $UiPaleta


#region script variables
@onready var popup = $popup_container/Popup
#endregion

signal in_particular

var is_hidden = false  # Variable para rastrear el estado del contenedor

func _ready() -> void:
	get_tree().root.size_changed.connect(reload_app)
	var estaciones: Array[Estacion] = GlobalData.get_data()
	SceneManager.add_scene(SceneManager.idScenePerfil,perfil)
	SceneManager.add_subviewport_reference(SceneManager.TIPO_NIVEL.PERFIL,sub_viewport_container)
	SceneManager.set_scroll_reference(scroll_container)
	AdjustWindowsSize()
	# Conectar señasles a las funciones correspondientes
	UIManager.set_ui_particular(ui_particular)  # Establecer la referencia a ui_particular
	SceneManager.set_initial_window()
	
	set_contador_sitios(estaciones)
	GlobalData.connect("datos_actualizados", _on_datos_actualizados)

func _on_datos_actualizados(estaciones: Array[Estacion]):
	set_contador_sitios(estaciones)

func reload_app():
	AdjustWindowsSize()

func AdjustWindowsSize():				
	var size = get_viewport().size
	SceneManager.set_viewport_size_x(size.x )
	for window : PanelContainer in windows_container.get_children():
		window.custom_minimum_size.x = size.x
	scroll_container.custom_minimum_size.x = size.x
	SceneManager.scroll_scene(SceneManager.current_tipoNivel,SceneManager.current_scene_id)
	
	
		

func _on_button_pressed():
	NavigationManager.emit_signal('ResetCameraPosition')

##region FUNCIONES PARA MOSTRAR U OCULTAR LISTA DE SITIOS
func _on_btn_lista_sitios_pressed():
	btn_lista_sitios.disabled = true
	if is_hidden:
		# Mostrar el contenedor
		btn_lista_sitios.icon = preload("res://Recursos/UI/img/Encabezado_B_Submenu/Boton_Expandir_b.png")
		_show_lista_sitios()
	else:
		# Esconder el contenedor
		btn_lista_sitios.icon = preload("res://Recursos/UI/img/Encabezado_B_Submenu/Boton_Expandir_a.png")
		_hide_lista_sitios()

func _on_world_interacted():
	if not is_hidden:
		_hide_lista_sitios()

func _show_lista_sitios():
	var tween = TweenManager.init_tween(_on_finish_tween)
	TweenManager.tween_animacion(tween, lista_sitios, "custom_minimum_size:y", 650, 0.5)
	lista_sitios.visible = true
	is_hidden = false

func _hide_lista_sitios():
	var tween = TweenManager.init_tween(_on_finish_tween)
	TweenManager.tween_animacion(tween, lista_sitios, "custom_minimum_size:y", 0, 0.5)
	is_hidden = true

func _on_finish_tween():
	btn_lista_sitios.disabled = false
	if is_hidden:
		lista_sitios.visible = false
##endregion

func _mostrar_world():
	SceneManager.scroll_scene(SceneManager.TIPO_NIVEL.PERFIL,SceneManager.idScenePerfil)
	
func _on_btn_close_popup_pressed():
	UIManager.popUpWindow.hide_popup()

func _on_scroll_container_ready() -> void:
	SceneManager.set_initial_window()

func _on_ready() -> void:
	SceneManager.set_initial_window()

func _on_sub_viewport_container_visibility_changed() -> void:
	background_flip_book.visible = true if !sub_viewport_container.visible else false
	
func set_contador_sitios(estaciones):
	var sitios_info = estaciones
	var offline_count = 0
	var online_count = 0
	
	
	for sitio:Estacion in sitios_info:
		if sitio.is_estacion_en_linea():
			online_count += 1
		else: 
			offline_count += 1
		
	lbl_offline_contador.text = str(offline_count)
	lbl_online_contador.text = str(online_count)


func _on_bnt_reset_camera_pressed() -> void:
	NavigationManager.emit_signal("ResetCameraPosition")	


func _unhandled_key_input(event: InputEvent) -> void:
	if Input.is_physical_key_pressed(KEY_P):
		ui_paleta.change_visibility( true if !ui_paleta.window.visible else false)
