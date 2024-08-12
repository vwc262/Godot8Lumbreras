extends Node

class_name  Estructura_Tripods

@export var cameras : Array[PhantomCamera3D]
@export var keyCodes : Array[Key]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _input(event):
	if event is InputEventKey and event.pressed:
		for i in range(cameras.size()):
			#cameras[i].priority = 0
			if(event.keycode == keyCodes[i]):
				cameras[i].priority = 5
				print("Switch to camera "+str(i))


