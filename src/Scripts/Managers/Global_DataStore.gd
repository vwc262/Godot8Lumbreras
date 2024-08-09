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
	
func set_Updated_Data(jsonData):
	update_Estaciones(jsonData)
	emit_signal("datos_actualizados", get_data())

#Contiene la informacion lite de las estaciones
func update_Estaciones(jsonData):
	var estacionesLite = jsonData["E"]
	for estacionId in jsonData["E"].keys():
		var estacion : Estacion = estacionesDict[int(estacionId)]
		estacion.enlace = estacionesLite[estacionId]["E"]
		estacion.tiempo = estacionesLite[estacionId]["T"]
		estacion.falla_energia = estacionesLite[estacionId]["F"]
		var signalsLite = estacionesLite[estacionId]["S"]		
		for signalKey in signalsLite.keys():									
			var signalUpdate : Señal = estacion.signals[int(signalKey)]
			signalUpdate.dentro_rango = 0 if signalsLite[signalKey] == -0.9 else 1
			signalUpdate.valor = signalsLite[signalKey]


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
		
		estacion.signals[señal.id_signal] = señal
	
	for linea_data in data["lineas"]:
		var linea = Linea.new(linea_data)
		estacion.lineas.append(linea)
	
	return estacion
