extends Node3D

signal IrA				

@export var IdEstacion : int = 0
@onready var modelo = $modelo_prueba

func _ready():
	var node = modelo.get_node("Pivote")
	NavigationManager.AddSiteAnchor(IdEstacion,node.global_position, node.rotation)

func _on_area_3d_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton and event.double_click:					
		NavigationManager.emit_signal("Go_TO",IdEstacion)
