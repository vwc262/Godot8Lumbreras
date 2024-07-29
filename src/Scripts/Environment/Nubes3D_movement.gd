extends Node3D

@export var speed = -.01


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	transform.origin += Vector3(speed,0,0)
	if transform.origin.x < -150:
		transform.origin = Vector3(300,0,0)
	pass
