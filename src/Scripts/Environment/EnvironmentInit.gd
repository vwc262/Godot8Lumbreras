extends Node

@onready var world_environment: WorldEnvironment = $"."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SceneManager.init_wolrd_environment_reference(world_environment)
