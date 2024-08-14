extends Node

class_name  ParticularCameraManager

@export var cameraTripod : Array[Estructura_Tripods]
@export var freeCamera : Camera3D
@export var phantomCamera : Camera3D
@export var buttonHome : Button
@export var buttons : Array[Button]
@export var virtualCameras : Array[PhantomCamera3D]
@export var keyCodes : Array[Key]
@export var virtualCameraIndex : int

@export var rotSpeed : float = 0.001

@export var originalRotations : Array[Basis]
var touch_points: Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	var i = 0
	for button in buttons:
		button.connect("pressed", func(): SwitchToVirtualCamera(i))
		i+=1
	for cam in virtualCameras:
		originalRotations.append(cam.transform.basis)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _input(event):
	
	if event is InputEventScreenTouch:
		handle_touch(event)
	elif event is InputEventScreenDrag:
		handle_drag(event)	
	elif event is InputEventKey and event.pressed:
		for i in range(virtualCameras.size()):
			if(event.keycode == keyCodes[i]):
				SwitchToVirtualCamera(i)
				

func SwitchToVirtualCamera(index):
	virtualCameraIndex = index
	for camera in virtualCameras:
		camera.priority = 0

	freeCamera.current = index == 0
	phantomCamera.current = index != 0

	virtualCameras[virtualCameraIndex].priority = 1
	virtualCameras[virtualCameraIndex].transform.basis = originalRotations[virtualCameraIndex]
	print("Enable POV camera "+ str(virtualCameraIndex))


func handle_touch(event: InputEventScreenTouch):
	pass
	
func handle_drag(event: InputEventScreenDrag):
	var cameraForward:Vector3 = virtualCameras[virtualCameraIndex].get_global_transform().basis.z
	var cameraRight:Vector3 = virtualCameras[virtualCameraIndex].get_global_transform().basis.x
	var cameraUp:Vector3 = virtualCameras[virtualCameraIndex].get_global_transform().basis.y
	touch_points[event.index] = event.position
	#print(event.relative.x)
	#print(event.relative.y)
	virtualCameras[virtualCameraIndex].rotate_y(rotSpeed * event.relative.x)
	virtualCameras[virtualCameraIndex].rotate(cameraRight, rotSpeed * event.relative.y)
	
	
	
	
