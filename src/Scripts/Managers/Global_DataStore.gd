# DatosGlobales.gd
extends Node
class_name DatosGlobales

signal datos_actualizados

# Variable para almacenar los datos estructurados
var estacionesDict = {}

# Función para actualizar los datos
func set_data(new_data):	
	for data in new_data:
		var estacion = parse_station_data(data)		
		estacionesDict[estacion.id_estacion] = estacion
	emit_signal("datos_actualizados", get_data())

# Función para obtener los datos
func get_data() -> Array[Estacion]:
	var estaciones :Array[Estacion] 
	estaciones.assign(estacionesDict.values())
	return estaciones	

func get_estacion(idEstacion: int) -> Estacion:
	return estacionesDict[idEstacion]	

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
