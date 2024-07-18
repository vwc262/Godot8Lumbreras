# Sitio.gd
extends Node

@export var signal_scene: PackedScene

@onready var texture_estado_enlace = $VBoxContainer/HBoxContainer/estado_enlace
@onready var lbl_numero_id = $VBoxContainer/HBoxContainer/Panel/numero_id
@onready var lbl_nombre_sitio = $VBoxContainer/HBoxContainer/nombre_fecha_contaier/VBoxContainer/nombre_sitio
@onready var lbl_fecha_sitio = $VBoxContainer/HBoxContainer/nombre_fecha_contaier/VBoxContainer/fecha_sitio
@onready var se_ales_sitios = $VBoxContainer/PanelContainer/señales_sitios

var estacion_ref: Estacion 
var signal_ref: Array[Señal]

# Función para recibir y establecer los datos de la estación
func set_datos(estacion: Estacion):
	estacion_ref = estacion
	signal_ref = estacion_ref.signals
	call_deferred("actualizar_datos")
	call_deferred("set_enlace")
	call_deferred("instanciar_señales")

# Función para actualizar los datos mostrados
func actualizar_datos():
	lbl_numero_id.text = str(estacion_ref.id_estacion)
	lbl_nombre_sitio.text = estacion_ref.nombre
	# Usar la función global para formatear la fecha
	lbl_fecha_sitio.text = GlobalUtils.formatear_fecha(estacion_ref.tiempo)

# Función para actualizar el estado del enlace
func set_enlace():
	if estacion_ref.enlace in [1, 2, 3]:
		texture_estado_enlace.modulate = Color(0, 1, 0)
	else:
		texture_estado_enlace.modulate = Color(1, 0, 0)

# Función para instanciar y actualizar señales
func instanciar_señales():
	# Limpiar señales anteriores
	for child in se_ales_sitios.get_children():
		child.queue_free()
	
	# Instanciar nuevas señales
	for signal_sitio in signal_ref:
		var signal_instance = signal_scene.instantiate()
		se_ales_sitios.add_child(signal_instance)
		signal_instance.set_datos(signal_sitio)

func _on_button_pressed():
	NavigationManager.emit_signal("Go_TO", estacion_ref.id_estacion)
