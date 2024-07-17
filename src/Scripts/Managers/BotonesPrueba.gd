extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	var world = preload("res://Scenes/Perfil/Main/NivelPruebas.tscn").instantiate()
	world.get_node("Domi")
	print("Hola ", world.get_node("Domi").get_children())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
