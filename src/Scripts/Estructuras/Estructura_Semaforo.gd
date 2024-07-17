# Semaforo.gd
extends Resource
class_name Semaforo

@export var id_signal: int
@export var normal: int
@export var preventivo: int
@export var critico: int
@export var altura: int

func _init(jsonData):
	self.id_signal = jsonData["idSignal"]
	self.normal = jsonData["normal"]
	self.preventivo = jsonData["preventivo"]
	self.critico = jsonData["critico"]
	self.altura = jsonData["altura"]
