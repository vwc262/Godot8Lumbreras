extends Node3D

signal IrA				

@export var IdEstacion : int = 0
@onready var modelo = $Mini_B5
@onready var labelSitio = $LabelNameSitio
var estacion: Estacion

func _ready():
	var node = modelo.get_node("Socket_Camara")
	NavigationManager.AddSiteAnchor(IdEstacion,node.global_position, node.rotation * 180/PI)
	estacion = GlobalData.get_estacion(IdEstacion)
	labelSitio.text = "%d - %s" % [estacion.id_estacion, estacion.nombre]

func _on_area_3d_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton and event.double_click:
		NavigationManager.emit_signal("Go_TO",IdEstacion)
