extends Node3D

@onready var material_dissolve: Material = $Edificio_485.material_override

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_viewport().get_camera_3d().get_parent().connect("on_position_changed",on_camera_position_changed)


func on_camera_position_changed(position:Vector3):
	var distanceFromCamera : float = position.distance_to(self.position)
	print("distance :" , distanceFromCamera)
	var weight = remap(distanceFromCamera,40,60,1,0)
	material_dissolve.set("shader_parameter/dissolve_amount",lerp(0,1,weight))	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
