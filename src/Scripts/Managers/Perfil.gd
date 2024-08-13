extends Node
#region Editor variables
@onready var scroll_container: ScrollContainer = $DynamicMargins/ScrollContainer
@onready var btn_lista_sitios: Button = $DynamicMargins/ScrollContainer/HBoxContainer/PerfilWindow/VB_MainContainer/main_container/ListaSitiosContainer/VBoxContainer/botones_container/HBoxContainer/BTN_ListaSitios
@onready var lista_sitios: Control = $DynamicMargins/ScrollContainer/HBoxContainer/PerfilWindow/VB_MainContainer/main_container/ListaSitiosContainer/VBoxContainer/PanelContainer/ListaSitios
@onready var header_fondo: TextureRect = $DynamicMargins/ScrollContainer/HBoxContainer/PerfilWindow/VB_MainContainer/header_container/header_fondo
@onready var dynamic_margins = $DynamicMargins
@onready var perfil: Node3D = $DynamicMargins/ScrollContainer/HBoxContainer/PerfilWindow/VB_MainContainer/main_container/SubViewportContainer/SubViewport/Perfil
@export var perfil_world_environment : Environment
@export var particular_world_environment : Environment
@onready var windows_container: HBoxContainer = $DynamicMargins/ScrollContainer/WindowsContainer
@onready var ui_particular: Control = $DynamicMargins/ScrollContainer/WindowsContainer/ParticularWindow/UiParticular

#endregion

#region script variables
@onready var popup = $popup_container/Popup
#endregion

signal in_particular

var is_hidden = false  # Variable para rastrear el estado del contenedor

	
		
	
func _ready() -> void:
	SceneManager.set_scroll_reference(scroll_container)	
	AdjustWindowsSize()		
	# Conectar señasles a las funciones correspondientes
	UIManager.set_ui_particular(ui_particular)  # Establecer la referencia a ui_particular	
	SceneManager.set_initial_window()
		
	
func AdjustWindowsSize():
	var size = get_viewport().size	
	SceneManager.set_viewport_size_x(size.x )
	for window : PanelContainer in windows_container.get_children():
		window.custom_minimum_size.x = size.x			

func _on_button_pressed():
	NavigationManager.emit_signal('ResetCameraPosition')

##region FUNCIONES PARA MOSTRAR U OCULTAR LISTA DE SITIOS
func _on_btn_lista_sitios_pressed():
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
	if is_hidden:
		lista_sitios.visible = false
##endregion


	

func _mostrar_world():
	SceneManager.load_scene(SceneManager.idScenePerfil)
	SceneManager.set_world_environment(SceneManager.TIPO_NIVEL.PERFIL)


func _on_btn_close_popup_pressed():
	UIManager.popUpWindow.hide_popup()


func _on_scroll_container_ready() -> void:
	SceneManager.set_initial_window()	


func _on_ready() -> void:
	SceneManager.set_initial_window()	
