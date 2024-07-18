# Sitio.gd
extends Node

@onready var texture_estado_enlace = $VBoxContainer/HBoxContainer/estado_enlace
@onready var lbl_numero_id = $VBoxContainer/HBoxContainer/Panel/numero_id
@onready var lbl_nombre_sitio = $VBoxContainer/HBoxContainer/nombre_fecha_contaier/VBoxContainer/nombre_sitio
@onready var lbl_fecha_sitio = $VBoxContainer/HBoxContainer/nombre_fecha_contaier/VBoxContainer/fecha_sitio

var estacion_ref: Estacion 

# Función para recibir y establecer los datos de la estación
func set_datos(estacion: Estacion):
	estacion_ref = estacion
	call_deferred("actualizar_datos")
	call_deferred("set_enlace")

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

func _on_button_pressed():
	NavigationManager.emit_signal("Go_TO",estacion_ref.id_estacion)
