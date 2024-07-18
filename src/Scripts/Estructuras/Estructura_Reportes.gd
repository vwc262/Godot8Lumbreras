extends Node
class_name Reportes

@export var id_signal: int
@export var valor: float
@export var tiempo: String

#Constructor
func _init(jsonData):
	self.id_signal = jsonData["idSignal"]
	self.valor = jsonData["valor"]
	self.tiempo = jsonData["tiempo"]
