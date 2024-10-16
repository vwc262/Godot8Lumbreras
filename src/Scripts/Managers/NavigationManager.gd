extends Node

signal world_interacted
signal Go_TO
signal ResetCameraPosition # Para reestablecer la posicion de la camara
signal CameraZoom
signal OnTweenFinished_MovimientoRealizado

var SitesAnchorPositionsDictionary = {}
var SitesAnchorRotationsDictionary = {}
var mini_3d_references = {}

var last_selected: int = 0

func AddSiteAnchor(idEstacion: int, position: Vector3, rotation: Vector3):
	SitesAnchorPositionsDictionary[idEstacion] = position
	SitesAnchorRotationsDictionary[idEstacion] = rotation

func GetSiteAnchor(idEstacion: int) -> Array:
	return [SitesAnchorPositionsDictionary[idEstacion], SitesAnchorRotationsDictionary[idEstacion]]

func set_lastid_selected(id_selected):
	last_selected = id_selected

func set_mini3d_reference(mini3d:Mini3D):
	mini_3d_references[mini3d.IdEstacion] = mini3d
	
func select_mini_3d():
	for mini3d:Mini3D in mini_3d_references.values():
		mini3d._set_selection(mini3d.IdEstacion == last_selected)
