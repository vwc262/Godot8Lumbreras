extends Node3D

@export var particular_scene : PackedScene = null
@export var idEstacion : int = 0
@onready var container = $Container

# Called when the node enters the scene tree for the first time.
func _ready():
	SceneManager.add_scene(idEstacion,self)
	container.add_child( particular_scene.instantiate()	)
	self.visible = false
	
