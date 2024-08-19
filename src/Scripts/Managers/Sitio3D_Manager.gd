extends Node3D

class_name Mini3D
signal IrA

@export var IdEstacion : int = 0
@export var fontSizeMax : int = 173
@export var fontSizeMin : int = 68
@export var outlineSizeMax : int = 83
@export var outlineSizeMin : int = 28
@export var minEtiquetaScale : float = 0.334
@export var maxEtiquetaScale : float = 0.85

@onready var modelo = $Mini_3D_04
@onready var etiqueta3D: Node3D = $Mini_3D_04/DatosEtiqueta3D

@onready var labelSitio = $LabelNameSitio
@onready var select_mesh: Node3D = $Mini_3D_04/SelectMesh
@onready var sprite_3d: Sprite3D = $Mini_3D_04/Sprite3D
@onready var mini_005: MeshInstance3D = $Mini_3D_04/Mini_005
@onready var material_emissivo: Material = mini_005.get_active_material(1)

var estacion: Estacion

@export var min_drag_elapsed_time: int = 300
@export var double_click_elapsed_time: int = 550
var pressed_over_area = false
var first_drag_time = Time.get_unix_time_from_system()

func _ready():
	material_emissivo.setup_local_to_scene()
	etiqueta3D.IdEstacion = IdEstacion;
	var node = modelo.get_node("Mini_005/Empty")
	NavigationManager.AddSiteAnchor(IdEstacion,node.global_position, node.rotation * 180/PI)
	_set_selection(false)
	NavigationManager.set_mini3d_reference(self)
	NavigationManager.connect("CameraZoom", _on_camera_moved)
	estacion = GlobalData.get_estacion(IdEstacion)
	labelSitio.text = "%s" % [estacion.abreviacion]

func _on_area_3d_input_event(_camera, event, _position, _normal, _shape_idx):
	
	if event is InputEventMouseButton and event.double_click:
		SceneManager.scroll_scene(SceneManager.TIPO_NIVEL.PARTICULAR, estacion.id_estacion)	
	
	if event is InputEventMouseButton and event.pressed:
		
		if !pressed_over_area:
			first_drag_time = Time.get_unix_time_from_system()
			pressed_over_area = true
			
		else:
			var current_time = Time.get_unix_time_from_system()	
			var difference = ((current_time - first_drag_time) * 1000)
	
			if difference > min_drag_elapsed_time:
				pressed_over_area = false
			
	if event is InputEventMouseButton and event.is_released():
		
		var current_time = Time.get_unix_time_from_system()
		var difference = ((current_time - first_drag_time) * 1000)

		if difference < min_drag_elapsed_time:
			if pressed_over_area:
				NavigationManager.emit_signal("Go_TO",IdEstacion)
				UIManager.seleccionar_sitio_id(IdEstacion)
				pressed_over_area = false


func _on_camera_moved(positionY: float, maxZoom, minZoom):	
	labelSitio.font_size = lerp(fontSizeMin, fontSizeMax, remap(positionY, minZoom, maxZoom, 0, 1))
	labelSitio.outline_size = lerp(outlineSizeMin, outlineSizeMax, remap(positionY, minZoom, maxZoom, 0, 1))
	var actualScale = lerp(minEtiquetaScale, maxEtiquetaScale, remap(positionY, minZoom, maxZoom, 0, 1))
	etiqueta3D.scale = Vector3(actualScale, actualScale, actualScale)

func _set_selection(do_select:bool):
	var active = true if do_select else false
	sprite_3d.visible = active
	material_emissivo.set("emission_enabled",active)
	#select_mesh.visible = true if do_select else false
