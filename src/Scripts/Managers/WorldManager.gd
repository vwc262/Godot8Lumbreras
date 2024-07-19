extends Node

@onready var btn_lista_sitios = $DynamicMargins/VB_MainContainer/main_container/ListaSitiosContainer/VBoxContainer/botones_container/HBoxContainer/BTN_ListaSitios
@onready var lista_sitios = $DynamicMargins/VB_MainContainer/main_container/ListaSitiosContainer/VBoxContainer/PanelContainer/ListaSitios


var is_hidden = false  # Variable para rastrear el estado del contenedor

func _ready():
	## Conectar la señal de interacción del World
	#NavigationManager.connect("world_interacted", _on_world_interacted)
	pass

func _on_button_pressed():
	NavigationManager.emit_signal('ResetCameraPosition')

##region FUNCIONES PARA MOSTRAR U OCULTAR LISTA DE SITIOS
func _on_btn_lista_sitios_pressed():
	if is_hidden:
		# Mostrar el contenedor
		_show_lista_sitios()
	else:
		# Esconder el contenedor
		_hide_lista_sitios()

func _on_world_interacted():
	if not is_hidden:
		_hide_lista_sitios()

func _show_lista_sitios():
	# Inicializar el Tween y configurar la animación para mostrar
	var tween = TweenManager.init_tween(_on_finish_tween)
	TweenManager.tween_animacion(tween, lista_sitios, "custom_minimum_size:y", 650, 0.5)  # 800 tamaño original
	lista_sitios.visible = true
	is_hidden = false

func _hide_lista_sitios():
	# Inicializar el Tween y configurar la animación para esconder
	var tween = TweenManager.init_tween(_on_finish_tween)
	TweenManager.tween_animacion(tween, lista_sitios, "custom_minimum_size:y", 0, 0.5)
	is_hidden = true

func _on_finish_tween():
	# Confirmación de que el tween ha terminado
	# print("Final del tween")
	if is_hidden:
		lista_sitios.visible = false
##endregion

#region FUNCIONES PARA MOSTRAR LA GRAFICA
func _on_btn_mostrar_grafica_pressed():
	pass # Replace with function body.

#endregion

