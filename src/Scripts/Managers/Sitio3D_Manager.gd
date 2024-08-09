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

@onready var modelo = $Mini_3D_05
@onready var etiqueta3D = $Mini_3D_05/DatosEtiqueta3D
@onready var labelSitio = $LabelNameSitio
@onready var select_mesh: Node3D = $Mini_3D_05/SelectMesh

var estacion: Estacion

func _ready():
	etiqueta3D.IdEstacion = IdEstacion;
	var node = modelo.get_node("Mini_005/Empty")
	NavigationManager.AddSiteAnchor(IdEstacion,node.global_position, node.rotation * 180/PI)
	_set_selection(false)
	NavigationManager.set_mini3d_reference(self)
	NavigationManager.connect("CameraZoom", _on_camera_moved)
	estacion = GlobalData.get_estacion(IdEstacion)
	labelSitio.text = "%s" % [estacion.abreviacion]

func _on_area_3d_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton and event.double_click:
		NavigationManager.emit_signal("Go_TO",IdEstacion)
		UIManager.seleccionar_sitio_id(IdEstacion)

func _on_camera_moved(positionY: float, maxZoom, minZoom):	
	labelSitio.font_size = lerp(fontSizeMin, fontSizeMax, remap(positionY, minZoom, maxZoom, 0, 1))
	labelSitio.outline_size = lerp(outlineSizeMin, outlineSizeMax, remap(positionY, minZoom, maxZoom, 0, 1))
	var actualScale = lerp(minEtiquetaScale, maxEtiquetaScale, remap(positionY, minZoom, maxZoom, 0, 1))
	etiqueta3D.scale = Vector3(actualScale, actualScale, actualScale)

func _set_selection(do_select:bool):
	select_mesh.visible = true if do_select else false
