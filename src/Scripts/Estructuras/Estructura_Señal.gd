# Signal.gd
extends Resource
class_name Señal

@export var id_signal: int
@export var id_estacion: int
@export var nombre: String
@export var valor: int
@export var tipo_signal: int
@export var ordinal: int
@export var indice_imagen: int
@export var dentro_limite: int
@export var dentro_rango: int
@export var linea: int
@export var habilitar: int
@export var semaforo: Semaforo


func _init(jsonData):
	self.id_signal = jsonData["idSignal"]
	self.id_estacion = jsonData["idEstacion"]
	self.nombre = jsonData["nombre"]
	self.valor = jsonData["valor"]
	self.tipo_signal = jsonData["tipoSignal"]
	self.ordinal = jsonData["ordinal"]
	self.indice_imagen = jsonData["indiceImagen"]
	self.dentro_limite = jsonData["dentroLimite"]
	self.dentro_rango = jsonData["dentroRango"]
	self.linea = jsonData["linea"]
	self.habilitar = jsonData["habilitar"]
