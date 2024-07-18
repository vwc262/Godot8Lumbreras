extends Node

signal world_interacted
signal Go_TO
signal ResetCameraPosition # Para reestablecer la posicion de la camara

var SitesAnchorPositionsDictionary  = {}

func AddSiteAnchor(idEstacion:int,value:Vector3):
	SitesAnchorPositionsDictionary[idEstacion] = value

func GetSiteAnchor(idEstacion:int) -> Vector3:
	return SitesAnchorPositionsDictionary[idEstacion]

