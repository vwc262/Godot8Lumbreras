# DatosGlobales.gd
extends Node
class_name DatosGlobales

signal datos_actualizados

# Variable para almacenar los datos estructurados
var estaciones : Array[Estacion] = []

# Función para actualizar los datos
func set_data(new_data):
	estaciones.clear()
	for data in new_data:
		var estacion = parse_station_data(data)
		estaciones.append(estacion)
	emit_signal("datos_actualizados", estaciones)

# Función para obtener los datos
func get_data() -> Array[Estacion]:
	return estaciones

func get_estacion(idEstacion: int) -> Estacion:
	var estacionesFiltter: Array[Estacion] = estaciones.filter(func(e: Estacion): 
		return e.id_estacion == idEstacion)
	var _estacion: Estacion
	var estacionesCount = estacionesFiltter.size()
	if estacionesCount >= 1:
		_estacion = estacionesFiltter[0]
	return _estacion

func parse_station_data(data) -> Estacion:
	var estacion = Estacion.new(data) #Se genera en el constructor
	for signal_data in data["signals"]:
		var señal = Señal.new(signal_data)
		
		if signal_data["semaforo"] != null:
			var semaforo = Semaforo.new(signal_data["semaforo"])
			señal.semaforo = semaforo
		
		estacion.signals.append(señal)
	
	for linea_data in data["lineas"]:
		var linea = Linea.new(linea_data)
		estacion.lineas.append(linea)
	
	return estacion
