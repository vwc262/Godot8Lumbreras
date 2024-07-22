@tool
extends Sprite3D

@export var textoBlock = "Texto Default"

# Called when the node enters the scene tree for the first time.
func _ready():
	$Label3D.text = textoBlock
	if $Label3D.text != textoBlock:
		$Label3D.text = textoBlock



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

