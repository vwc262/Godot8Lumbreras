extends Node3D

#region Propiedades de editor
@export_group('Pan')
@export var can_pan: bool
@export var pan_speed = 0
@export var minX = -15 # -13 , 20
@export var maxX = 20 # -13 , 20
@export var minZ = -80
@export var maxZ = -20
@export var minY = 5
@export var maxY = 50

@export_group('Rotation')
@export var can_rotate: bool
@export var rotate_speed = 0.9
@export var rotate_treshold = 15
@export var initialRotationCamera = -75
@export var LimitRotationCamera = -15
@export var minRotationY : float = -13
@export var maxRotationY : float= 13
@export var offSetDistanceInclination : float = 5
@export var tilt_speed : float = 1
@export var tilt_threshold:float=10

@export_group('Zoom')
@export var zoom_speed = 0.01
@export var can_zoom: bool
@export var maxZoom: float
@export var initialZoom: float
@export var speedAnimation: float
@export var zoom_treshold : float = 5
@export var pan_dist := 200
@export var max_pan_speed : float = 0.05
@export var z_Depth : float = 100
#endregion

@onready var camera_3_dp : Node3D = $Camera3Dp
@onready var camera_3_dp2 : Camera3D = $Camera3Dp

#region Signals
signal on_position_changed
#endregion

#region Propiedades para logica
var last_distance = 0
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

#tilt variables
var previous_y_diff  : float = 0
var previous_distance:float=0
var client_size: Vector2;
var vector_proyectado: Vector3;
#endregion

# Called when the node enters the scene tree for the first time.
func _ready():
	initialRotationCamera = camera_3_dp.rotation_degrees.x
	#camera_3_dp.rotation_degrees.x = initialRotationCamera #Se guarda la rotacion inicial en x de la camara
	NavigationManager.connect('ResetCameraPosition',ResetCameraPosition) #Suscripcion de evento
	initalCameraPosition = position # se guarda la posicion inicial de la camara
	
	# esta pensado para portrait
	client_size = DisplayServer.screen_get_size();
	client_size.x = client_size.x / client_size.y
	client_size.y = 1


func ResetCameraPosition():
	DisableNavigation()
	var tweenRot := TweenManager.init_tween(OnTweenFinished_MovimientoRealizado)
	tweenRot.set_parallel()
	tweenRot.tween_property(self,"position",initalCameraPosition,speedAnimation)
	tweenRot.tween_property(self,"rotation_degrees",initialRotationCamera,speedAnimation)
	
	var tweenRotCamara := TweenManager.init_tween(func(): return)
	tweenRotCamara.tween_property(camera_3_dp,"rotation_degrees",Vector3(initialRotationCamera,0,0),speedAnimation)
	
func DisableNavigation():
	can_zoom= false
	can_pan = false

func OnTweenFinished_MovimientoRealizado():
	can_zoom= true
	can_pan = true
	isTween = false

func _input(event):
	if event is InputEventScreenTouch:
		handle_touch(event)
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
		start_distance = touch_point_positions[1].distance_to(touch_point_positions[0])
		last_distance = start_distance
		start_zoom = position.y

		var current: Vector2 = touch_point_positions[1] - touch_point_positions[0]
		angle = anclaDistancia.normalized().dot(current.normalized())
		anclaDistancia = touch_point_positions[1] - touch_point_positions[0]
		
		#region hector
		var _touches = touch_points.values()
		var vector_centro: Vector2 = ((_touches[1] - _touches[0]) / 2) + _touches[0]
		vector_proyectado = camera_3_dp2.project_position(vector_centro, z_Depth).normalized()
		vector_proyectado = Vector3(vector_proyectado.x * client_size.y, vector_proyectado.y * client_size.x, vector_proyectado.z * client_size.x)
		#endregion

	elif touch_points.size() < 2:
		start_distance = 0
		angle = 0
		anclaDistancia = Vector2(0,0)
		previous_y_diff  = 0
		previous_distance = 0
		last_distance = 0

func handle_drag(event: InputEventScreenDrag):
	#var cameraForward:Vector3 = camera_3_dp.get_global_transform().basis.z
	emit_signal("on_position_changed",position)
	ID_Select = 0
	UIManager.deselect_all_sitios()
	NavigationManager.set_lastid_selected(ID_Select)
	touch_points[event.index] = event.position
	var parentTransform = get_global_transform()
	var forward: Vector3 = parentTransform.basis.z
	var right: Vector3 = parentTransform.basis.x

	AdjustPanSpeedByZoom()
	
	if touch_points.size() == 1:
		if can_pan:
			var pan_vector = (forward + (-event.relative.x * right ) + (-event.relative.y * forward)) * pan_speed
			pan_vector.y = 0
			# comentado
			global_translate(pan_vector)

	elif touch_points.size() >= 2:
		#var up: Vector2 = Vector2(0,1)
		var touch_point_positions = touch_points.values()
		var current_finger_positions: Vector2 = touch_point_positions[1] - touch_point_positions[0]
		var current_dist = touch_point_positions[1].distance_to(touch_point_positions[0])
		#var zoom_factor = current_dist / start_distance

		if can_rotate:
			var touch = touch_points.values()
			var delta : Vector2 = touch[1] - touch[0]
			# comentado
			if(abs(delta.angle_to(anclaDistancia) * 1000) > rotate_treshold):
				rotate_camera(rotate_speed * sign(delta.angle_to(anclaDistancia)))
			
			anclaDistancia = delta;
						
		if can_zoom:	
			# prioridad al zoom mediante una tolerancia
			if abs(get_delta_distance(current_dist)) > zoom_treshold:#zoom
				var direction = -1 if current_dist > last_distance else 1 
				#position += cameraForward * direction * zoom_speed
				position += vector_proyectado * -direction * zoom_speed * 8
				last_distance = current_dist
			elif previous_y_diff != 0: #tilt
				if abs(current_finger_positions.y - previous_y_diff) > tilt_threshold:
					var direction : float = sign(event.relative.y)
					# comentado
					#camera_3_dp.rotation_degrees.x += direction * tilt_speed
					position.y += direction * tilt_speed
			previous_y_diff  = current_finger_positions.y	
			previous_distance = current_dist

			#position.y = start_zoom / zoom_factor
			limit_zoom()
			#camera_3_dp.rotation_degrees.x =  lerpf(initialRotationCamera,LimitRotationCamera,inclinate_camera())

	#position.x = clamp(position.x, minX * factorZoom, maxX * factorZoom)
	#position.z = clamp(position.z, minZ * factorZoom, maxZ * factorZoom)
	#position.y = clamp(position.y, minY * factorZoom, maxY * factorZoom)
	position.x = clamp(position.x, minX, maxX)
	position.z = clamp(position.z, minZ, maxZ)
	position.y = clamp(position.y, minY, maxY)

func rotate_camera(currentangle: float):
	rotation_degrees.y += -currentangle
	#rotation_degrees.y = clamp(rotation_degrees.y, minRotationY, maxRotationY)

func limit_zoom():
	#position.y +=  clamp(position.y, maxZoom, initialZoom )
	print("Current position: " ,position)
	pass

func inclinate_camera(current_dist)->float:
	var current = 0 #Default uno para que mantenga la vista top
	current = remap(position.y , current_dist, maxZoom, 0, 1)
	return current

func GetZoomFactor():
	factorZoom = remap(position.y,initialZoom,maxZoom,0,1) + 1
	return factorZoom

func AdjustPanSpeedByZoom():
	pan_speed = remap(GetZoomFactor(), 1.0, 2.0, .05, max_pan_speed)

func get_delta_distance(currentDistance:float):
	return currentDistance - last_distance 

