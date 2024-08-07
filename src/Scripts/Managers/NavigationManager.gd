extends Node

signal world_interacted
signal Go_TO
signal ResetCameraPosition # Para reestablecer la posicion de la camara
signal CameraZoom

var SitesAnchorPositionsDictionary = {}
var SitesAnchorRotationsDictionary = {}
var last_selected: int = 0

func AddSiteAnchor(idEstacion: int, position: Vector3, rotation: Vector3):
	SitesAnchorPositionsDictionary[idEstacion] = position
	SitesAnchorRotationsDictionary[idEstacion] = rotation

func GetSiteAnchor(idEstacion: int) -> Array:
	return [SitesAnchorPositionsDictionary[idEstacion], SitesAnchorRotationsDictionary[idEstacion]]

func set_lastid_selected(id_selected):
	last_selected = id_selected
