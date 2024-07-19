extends Node

signal world_interacted
signal Go_TO
signal ResetCameraPosition # Para reestablecer la posicion de la camara

var SitesAnchorPositionsDictionary  = {}
var SitesAnchorRotationsDictionary  = {}

func AddSiteAnchor(idEstacion:int,position:Vector3, rotation:Vector3):
	SitesAnchorPositionsDictionary[idEstacion] = position
	SitesAnchorRotationsDictionary[idEstacion] = rotation

func GetSiteAnchor(idEstacion:int) -> Array:
	return [SitesAnchorPositionsDictionary[idEstacion], SitesAnchorRotationsDictionary[idEstacion]]

