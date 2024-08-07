extends Node3D

#region Propiedades de editor
@export_group('Pan')
@export var can_pan: bool
@export var pan_speed = 0.01
@export var minX = -13 # -13 , 20
@export var maxX = 20 # -13 , 20
@export var minZ = -10
@export var maxZ = 10

@export_group('Rotation')
@export var can_rotate: bool
@export var rotate_speed = 0.9
@export var rotate_treshold = 15
@export var initialRotationCamera = -75
@export var LimitRotationCamera = -15
@export var minRotationY : float = -13
@export var maxRotationY : float= 13
@export var offSetDistanceInclination : float = 5

@export_group('Zoom')
@export var zoom_speed = 0.01
@export var can_zoom: bool
@export var maxZoom: float
@export var initialZoom: float
@export var speedAnimation: float

@export_group('Material')
@export var maxBlurIntensity: float = 3.0

#endregion

#region Propiedades para logica
var touch_points: Dictionary = {}
var start_distance
var start_zoom
var start_angle

var current_angle
var anclaDistancia : Vector2
var angle : float = 0
var initalCameraPosition : Vector3
var isTween: bool

var ID_Select = 0
var factorZoom: float;
#endregion

@onready var blurMaterial:Material = $Camera3D/ColorRect.material

#region Godot Functions
func _ready():
	$Camera3D.rotation_degrees.x = initialRotationCamera #Se guarda la rotacion inicial en x de la camara
	NavigationManager.connect("Go_TO",MoverCamara)  #Suscripcion de evento
	NavigationManager.connect('ResetCameraPosition',ResetCameraPosition) #Suscripcion de evento
	initalCameraPosition = position # se guarda la posicion inicial de la camara
	

func _input(event):
	if event is InputEventScreenTouch:
		handle_touch(event)
		NavigationManager.emit_signal("world_interacted")
	elif event is InputEventScreenDrag:
		handle_drag(event)
		
#endregion		

#region CustomFunctions
#Se hacen los presets iniciales del touch event
func handle_touch(event: InputEventScreenTouch):
	if event.pressed:
		touch_points[event.index] = event.position
	else:
		touch_points.erase(event.index)

	if touch_points.size() == 2:
		var touch_point_positions = touch_points.values()
		start_distance = touch_point_positions[0].distance_to(touch_point_positions[1])
		start_zoom = position.y

		var current: Vector2 = touch_point_positions[1] - touch_point_positions[0]
		angle = anclaDistancia.normalized().dot(current.normalized())
		anclaDistancia = touch_point_positions[1] - touch_point_positions[0]

	elif touch_points.size() < 2:
		start_distance = 0
		angle = 0
		anclaDistancia = Vector2(0,0)

func handle_drag(event: InputEventScreenDrag):
	ID_Select = 0
	UIManager.deselect_all_sitios()
	NavigationManager.set_lastid_selected(ID_Select)
	touch_points[event.index] = event.position
	var parentTransform = get_global_transform()
	var forward: Vector3 = parentTransform.basis.z
	var right: Vector3 = parentTransform.basis.x

	SetBlurMaterial()
	AdjustPanSpeedByZoom()
	
	if touch_points.size() == 1:
		if can_pan:
			var pan_vector = (forward + (-event.relative.x * right ) + (-event.relative.y * forward)) * pan_speed
			pan_vector /= initialZoom *.5
			pan_vector.y = 0
			global_translate(pan_vector)

	elif touch_points.size() == 2:
		var touch_point_positions = touch_points.values()
		var current_dist = touch_point_positions[1].distance_to(touch_point_positions[0])
		var zoom_factor = current_dist / start_distance


		if can_rotate:
			var touch = touch_points.values()
			var delta : Vector2 = touch[1] - touch[0]
			if(abs(delta.angle_to(anclaDistancia) * 1000) > rotate_treshold):
				rotate_camera(rotate_speed * sign(delta.angle_to(anclaDistancia)))
			anclaDistancia = delta;

		if can_zoom:
			position.y = start_zoom / zoom_factor
			limit_zoom()
			NavigationManager.emit_signal("CameraZoom", position.y, initialZoom, maxZoom)
			$Camera3D.rotation_degrees.x = lerp(initialRotationCamera, LimitRotationCamera, inclinate_camera())
	position.x = clamp(position.x,minX * factorZoom ,maxX * factorZoom )
	position.z = clamp(position.z,minZ * factorZoom,maxZ * factorZoom)

func rotate_camera(currentangle: float):
	rotation_degrees.y += -currentangle
	rotation_degrees.y = clamp(rotation_degrees.y,minRotationY,maxRotationY)

func limit_zoom():
	position.y = clamp(position.y, maxZoom,initialZoom )

func inclinate_camera()->float:
	var val = 0 #Default uno para que mantenga la vista top
	if position.y < initialZoom - offSetDistanceInclination:
		val = remap(position.y, initialZoom - offSetDistanceInclination, maxZoom, 0, 1)
	return val

func OnTweenFinished_MovimientoRealizado():
	can_zoom= true
	can_pan = true
	isTween = false	
	NavigationManager.emit_signal("CameraZoom", position.y, initialZoom, maxZoom)
	
func OnTweenFinished_Blur():
	pass

func MoverCamara(idEstacion:int):
	DisableNavigation()
	
	var transform: Array
	var tweenBlur := TweenManager.init_tween(OnTweenFinished_Blur)
	
	if ID_Select != idEstacion:
		ID_Select = idEstacion
		if !isTween:
			NavigationManager.set_lastid_selected(ID_Select)
			var tween := TweenManager.init_tween(OnTweenFinished_MovimientoRealizado)
			isTween = true
			transform = NavigationManager.GetSiteAnchor(idEstacion)
			var new_vec3 = Vector3(rotation.x, transform[1].y, rotation.z)
			tween.set_parallel()
			var positionToGo = transform[0]
			positionToGo.y = clamp(positionToGo.y,maxZoom,initialZoom)
			tween.tween_property(self,"position", positionToGo, speedAnimation)			
			var val = remap(positionToGo.y, initialZoom - offSetDistanceInclination, maxZoom, 0, 1)
			tween.tween_property($Camera3D, "rotation_degrees", Vector3(lerp(initialRotationCamera, LimitRotationCamera, val),0,0), speedAnimation)
			tweenBlur.tween_property(blurMaterial, "shader_parameter/blur_amount", maxBlurIntensity, speedAnimation)
			
	else:
		if !isTween:
			ID_Select = 0
			ResetCameraPosition()
			tweenBlur.tween_property(blurMaterial, "shader_parameter/blur_amount", 0, speedAnimation)
			NavigationManager.set_lastid_selected(ID_Select)
			

func ResetCameraPosition():
	DisableNavigation()
	var tweenRot := TweenManager.init_tween(OnTweenFinished_MovimientoRealizado)
	tweenRot.set_parallel()
	tweenRot.tween_property(self,"position",initalCameraPosition,speedAnimation)
	#tweenRot.tween_property(self,"rotation_degrees",Vector3(0,0,0),1.5)
	
	var tweenRotCamara := TweenManager.init_tween(func(): return)
	tweenRotCamara.tween_property($Camera3D,"rotation_degrees",Vector3(initialRotationCamera,0,0),speedAnimation)

func SetBlurMaterial():	
	var blurAmount = lerp(0.0, maxBlurIntensity, remap(GetZoomFactor(), 1.0, 2.0, 0, 1))
	blurMaterial.set_shader_parameter("blur_amount", blurAmount)

#Deshabilita la navegacion mientras este ocurriendo una animacion
func DisableNavigation():
	can_zoom= false
	can_pan = false

func GetZoomFactor():
	factorZoom = remap(position.y,35,2,0,1) + 1
	return factorZoom

func AdjustPanSpeedByZoom():	
	pan_speed = lerp(0.6,0.18,remap(GetZoomFactor(), 1.0, 2.0, 0, 1))
	# normal .6
	#at max zoom 0.18
	

#endregion

