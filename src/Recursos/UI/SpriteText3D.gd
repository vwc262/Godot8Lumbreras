@tool
extends Sprite3D

@export var offsetLocation = Vector3(0,0,0):
	set(p_offsetLocation):
		if p_offsetLocation != offsetLocation:
			offsetLocation = p_offsetLocation
			_ready()
			
@export var textoBlock = "Texto Default":
	set(p_textoBlock):
		if p_textoBlock != textoBlock:
			textoBlock = p_textoBlock
			_ready()

# Called when the node enters the scene tree for the first time.
func _ready():
	$Label3D.position = offsetLocation
	$Label3D.text = textoBlock
	if $Label3D.text != textoBlock:
		$Label3D.text = textoBlock



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

