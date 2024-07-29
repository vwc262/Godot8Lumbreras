extends Control

@onready var btn_lista = $VBoxContainer/main_container/detalles_container/VBoxContainer/botones_container/HBoxContainer/btn_lista
@onready var sitio_detalles = $VBoxContainer/main_container/detalles_container/VBoxContainer/sitio_detalles
@onready var ui_particular = $"."

@export var new_icon : Texture2D

var original_icon : Texture2D
var is_new_icon_active = false

var is_hidden: bool = false

func _ready():
	original_icon = btn_lista.icon  # Guarda el ícono original
	btn_lista.connect("pressed", _on_btn_lista_pressed)

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
