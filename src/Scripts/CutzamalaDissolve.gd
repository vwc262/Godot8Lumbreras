extends Node3D

#@onready var material_dissolve: Material = $Edificio_485.material_override

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	#get_viewport().get_camera_3d().get_parent().connect("on_position_changed",on_camera_position_changed)


#func on_camera_position_changed(position_camera:Vector3):
	#pass
	#var distanceFromCamera : float = position_camera.distance_to(self.position_camera)
	#var weight = remap(distanceFromCamera,40,60,1,0)
	#material_dissolve.set("shader_parameter/dissolve_amount",lerp(0,1,weight))	
