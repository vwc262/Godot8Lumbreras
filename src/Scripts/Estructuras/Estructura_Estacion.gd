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

const tolerancia_minutos : int = 15

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

func is_estacion_en_linea() -> bool:	
	var current_time = Time.get_unix_time_from_datetime_dict(Time.get_datetime_dict_from_system(false))
	var estacion_time  = Time.get_unix_time_from_datetime_string(tiempo)
	var difference_minutes = (current_time - estacion_time) / 60.0
	if(difference_minutes > tolerancia_minutos):
		return false			
	return  enlace in [1, 2, 3] 
	
	
