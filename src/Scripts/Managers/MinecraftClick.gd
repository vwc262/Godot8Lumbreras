extends Node3D

signal IrA				

@export var IdEstacion : int = 0
@onready var modelo = $Purif_Generica_001_v001

func _ready():
	var node = modelo.get_node("Socket_camara")
	NavigationManager.AddSiteAnchor(IdEstacion,node.global_position, node.rotation * 180/PI)

func _on_area_3d_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton and event.double_click:
		NavigationManager.emit_signal("Go_TO",IdEstacion)
