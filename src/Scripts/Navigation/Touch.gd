extends Node3D

@export_group('Pan')
@export var can_pan: bool
@export var pan_speed = 0.01

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
@export var maxZoom:float
@export var initialZoom:float


var touch_points: Dictionary = {}
var start_distance
var start_zoom
var start_angle

var current_angle
var anclaDistancia : Vector2
var angle : float = 0
var initalCameraPosition : Vector3

func _ready():
	$Camera3D.rotation_degrees.x = initialRotationCamera
	NavigationManager.connect("Go_TO",MoverCamara)
	NavigationManager.connect('ResetCameraPosition',ResetCameraPosition)
	initalCameraPosition = position

func _input(event):
	if event is InputEventScreenTouch:
		handle_touch(event)
	elif event is InputEventScreenDrag:
		handle_drag(event)

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
	touch_points[event.index] = event.position
	var parentTransform = get_global_transform()
	var forward: Vector3 = parentTransform.basis.z
	var right: Vector3 = parentTransform.basis.x

	if touch_points.size() == 1:
		if can_pan:
			var pan_vector = (forward + (-event.relative.x * right ) + (-event.relative.y * forward)) * pan_speed
			pan_vector /= initialZoom
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
			$Camera3D.rotation_degrees.x = lerp(initialRotationCamera,LimitRotationCamera,inclinate_camera())


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
	

func crearMiTween(callBack) -> Tween:
	var tween = create_tween()
	tween.connect("finished",callBack)
	return tween
	
func MovimientoRealizado():
	pass

func MoverCamara(idEstacion:int):
	var tween := crearMiTween(MovimientoRealizado)
	tween.tween_property(self,"position",NavigationManager.GetSiteAnchor(idEstacion),1.5)

func ResetCameraPosition():
	var tweenRot := crearMiTween(MovimientoRealizado)
	tweenRot.tween_property(self,"rotation_degrees",Vector3(0,0,0),.5)
	var tweenRotCamara := crearMiTween(MovimientoRealizado)
	tweenRotCamara.tween_property($Camera3D,"rotation_degrees",Vector3(initialRotationCamera,0,0),.5)
	var tween := crearMiTween(MovimientoRealizado)
	tween.tween_property(self,"position",initalCameraPosition,1)
