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
@export var signals: Array = []
@export var lineas: Array = []
@export var conexiones: int
@export var fallas: int
@export var tipo_poleo: int
