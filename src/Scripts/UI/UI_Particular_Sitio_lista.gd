
extends Control

@onready var lbl_nombre_sitio = $sitio_container/HBoxContainer/VBoxContainer/lbl_nombre_sitio
@onready var lbl_fecha_sitio = $sitio_container/HBoxContainer/VBoxContainer/lbl_fecha_sitio
@onready var texture_enlace = $sitio_container/HBoxContainer/sitio_enlace_container/texture_enlace

@export var texture_online: Texture2D
@export var texture_offline: Texture2D

func set_datos(sitio: Estacion):
	lbl_nombre_sitio.text = sitio.nombre
	lbl_fecha_sitio.text = GlobalUtils.formatear_fecha(sitio.tiempo)
	
	if sitio.enlace in [1, 2, 3]:
		texture_enlace.texture = texture_online
	elif sitio.enlace == 0:
		texture_enlace.texture = texture_offline
