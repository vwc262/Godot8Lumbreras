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

var resetViewCont : int

# Called when the node enters the scene tree for the first time.
func _ready():
	var i = 0
	for button in buttons:
		button.connect("pressed", func(): SwitchToVirtualCamera(i))
		i+=1
	for cam in virtualCameras:
		originalRotations.append(cam.transform.basis)
	
	SwitchToVirtualCamera(4)	

func _process(_delta: float) -> void: 
	if resetViewCont < 0:
		virtualCameras[virtualCameraIndex].transform.basis = InterpolateBasis(virtualCameras[virtualCameraIndex].transform.basis, originalRotations[virtualCameraIndex], 0.01)
	else:
		resetViewCont -= 1
	
func _input(event):
	
	if event is InputEventScreenTouch:
		handle_touch(event)
	elif event is InputEventScreenDrag:
		handle_drag(event)	
	#elif event is InputEventKey and event.pressed:
		#for i in range(virtualCameras.size()):
			#if(event.keycode == keyCodes[i]):
				#SwitchToVirtualCamera(i)
				

func SwitchToVirtualCamera(index):
	virtualCameraIndex = index
	for camera in virtualCameras:
		camera.priority = 0

	freeCamera.current = index == 4
	phantomCamera.current = index != 4

	virtualCameras[virtualCameraIndex].priority = 1
	virtualCameras[virtualCameraIndex].transform.basis = originalRotations[virtualCameraIndex]
	print("Enable POV camera "+ str(virtualCameraIndex))


func handle_touch(_event: InputEventScreenTouch):
	pass
	
func handle_drag(event: InputEventScreenDrag):
	#var cameraForward:Vector3 = virtualCameras[virtualCameraIndex].get_global_transform().basis.z
	var cameraRight:Vector3 = virtualCameras[virtualCameraIndex].get_global_transform().basis.x
	#var cameraUp:Vector3 = virtualCameras[virtualCameraIndex].get_global_transform().basis.y
	touch_points[event.index] = event.position
	#print(event.relative.x)
	#print(event.relative.y)
	virtualCameras[virtualCameraIndex].rotate_y(rotSpeed * event.relative.x)
	virtualCameras[virtualCameraIndex].rotate(cameraRight, rotSpeed * event.relative.y)
	
	if virtualCameras[virtualCameraIndex].rotation.x > deg_to_rad(45):
		virtualCameras[virtualCameraIndex].rotation.x = deg_to_rad(45)
	if virtualCameras[virtualCameraIndex].rotation.x < deg_to_rad(-45):
		virtualCameras[virtualCameraIndex].rotation.x = deg_to_rad(-45)
	
	resetViewCont = 200
	
func InterpolateBasis(basis_1 : Basis, basis_2 : Basis, lambda : float) -> Basis:
	var res = basis_1
	res.x = basis_1.x + (basis_2.x - basis_1.x)*lambda
	res.y = basis_1.y + (basis_2.y - basis_1.y)*lambda
	res.z = basis_1.z + (basis_2.z - basis_1.z)*lambda
	return res
