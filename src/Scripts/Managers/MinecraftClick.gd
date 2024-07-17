extends Node3D

signal IrA				

@export var IdEstacion : int = 0

func _ready():
	NavigationManager.AddSiteAnchor(IdEstacion,position)

func _on_area_3d_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton and event.button_mask == MOUSE_BUTTON_LEFT:					
		NavigationManager.emit_signal("Go_TO",IdEstacion)
