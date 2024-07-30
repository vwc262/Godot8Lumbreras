# Estacion.gd
extends Resource
class_name Estacion

@export var id_estacion: int
@export var nombre: String
@export var latitud: float
@export var longitud: float
@export var tiempo: String
@export var enlace: int
@export var falla_energia: int
@export var abreviacion: String
@export var tipo_estacion: int
@export var signals = {}
@export var lineas: Array[Linea] = []
@export var conexiones: int
@export var fallas: int
@export var tipo_poleo: int

#Constructo Estacion
func _init(jsonData):
	self.id_estacion = jsonData["idEstacion"]
	self.nombre = jsonData["nombre"]
	self.latitud = jsonData["latitud"]
	self.longitud = jsonData["longitud"]
	self.tiempo = jsonData["tiempo"]
	self.enlace = jsonData["enlace"]
	self.falla_energia = jsonData["fallaEnergia"]
	self.abreviacion = jsonData["abreviacion"]
	self.tipo_estacion = jsonData["tipoEstacion"]
	self.conexiones = jsonData["conexiones"]
	self.fallas = jsonData["fallas"]
	self.tipo_poleo = jsonData["tipoPoleo"]
	
	
