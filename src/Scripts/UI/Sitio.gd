extends Node

@onready var texture_estado_enlace = $VBoxContainer/HBoxContainer/estado_enlace
@onready var lbl_numero_id = $VBoxContainer/HBoxContainer/Panel/numero_id
@onready var lbl_nombre_sitio = $VBoxContainer/HBoxContainer/nombre_fecha_contaier/VBoxContainer/nombre_sitio
@onready var lbl_fecha_sitio = $VBoxContainer/HBoxContainer/nombre_fecha_contaier/VBoxContainer/fecha_sitio


var estacion_ref: Estacion 

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_datos(estacion: Estacion):
	estacion_ref = estacion

	
	call_deferred("actualizar_datos")
	call_deferred("set_enlace")

func actualizar_datos():
	lbl_numero_id.text = str(estacion_ref.id_estacion)
	lbl_nombre_sitio.text = estacion_ref.nombre
	lbl_fecha_sitio.text = estacion_ref.tiempo

func set_enlace():
	if estacion_ref.enlace in [1,2,3]:
		texture_estado_enlace.modulate = Color(0,1,0)
	else:
		texture_estado_enlace.modulate =  Color(1,0,0)
