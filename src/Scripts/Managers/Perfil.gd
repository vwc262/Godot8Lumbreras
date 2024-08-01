extends Node
#region Editor variables
@onready var btn_lista_sitios = $DynamicMargins/VB_MainContainer/main_container/ListaSitiosContainer/VBoxContainer/botones_container/HBoxContainer/BTN_ListaSitios
@onready var lista_sitios = $DynamicMargins/VB_MainContainer/main_container/ListaSitiosContainer/VBoxContainer/PanelContainer/ListaSitios
@onready var header_fondo = $DynamicMargins/VB_MainContainer/header_container/header_fondo
@onready var ui_particular = $UiParticular
@onready var dynamic_margins = $DynamicMargins
@onready var perfil = $DynamicMargins/VB_MainContainer/main_container/SubViewportContainer/SubViewport/Perfil
#endregion

#region script variables

#endregion

signal in_particular

var is_hidden = false  # Variable para rastrear el estado del contenedor

func _ready():
	SceneManager.add_scene(SceneManager.idScenePerfil,perfil)
	# Conectar señales a las funciones correspondientes
	UIManager.set_ui_particular(ui_particular)  # Establecer la referencia a ui_particular
	#UIManager.connect("mostrar_world", _mostrar_world)  # Conectar la señal mostrar_world

func _on_button_pressed():
	NavigationManager.emit_signal('ResetCameraPosition')

##region FUNCIONES PARA MOSTRAR U OCULTAR LISTA DE SITIOS
func _on_btn_lista_sitios_pressed():
	if is_hidden:
		# Mostrar el contenedor
		btn_lista_sitios.icon = preload("res://Recursos/UI/img/Menu_pie/MenuPie_Expandir_B.png")
		_show_lista_sitios()
	else:
		# Esconder el contenedor
		btn_lista_sitios.icon = preload("res://Recursos/UI/img/Menu_pie/MenuPie_Expandir_A.png")
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

##region FUNCIONES PARA MOSTRAR LA GRAFICA
func _on_btn_graficar_button_down():
	GlobalUtils.ChartControl.visible = not GlobalUtils.ChartControl.visible
##endregion

# Actualiza esta función para usar UIManager
func _on_btn_particular_pressed():
	UIManager.mostrar_particular()	
	SceneManager.load_scene(1)

func _mostrar_world():
	SceneManager.load_scene(SceneManager.idScenePerfil)
