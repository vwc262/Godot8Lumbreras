extends Node3D

@export var MaxAlpha: float = 0.86
@onready var sprite_3d = $Sprite3D
@onready var sprite_3d_2: Sprite3D = $Sprite3D2

# Called when the node enters the scene tree for the first time.
func _ready():
	NavigationManager.connect("CameraZoom", _VisibilityTree)

func _VisibilityTree(value: float, maxZoom: float, minZoom: float):
	var deltaAlpha = lerp(MaxAlpha, 0.0, remap(value, minZoom, maxZoom, 0, 1))
	#sprite_3d.modulate.a = deltaAlpha
	#sprite_3d_2.modulate.a = deltaAlpha
