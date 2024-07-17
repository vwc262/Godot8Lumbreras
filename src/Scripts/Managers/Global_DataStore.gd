# DatosGlobales.gd
extends Node
class_name DatosGlobales

signal datos_actualizados

# Variable para almacenar los datos estructurados
var estaciones = []

# Función para actualizar los datos
func set_data(new_data):
	estaciones.clear()
	for data in new_data:
		var estacion = parse_station_data(data)
		estaciones.append(estacion)
	emit_signal("datos_actualizados", estaciones)

# Función para obtener los datos
func get_data():
	return estaciones

func parse_station_data(data):
	var estacion = Estacion.new()
	estacion.id_estacion = data["idEstacion"]
	estacion.nombre = data["nombre"]
	estacion.latitud = data["latitud"]
	estacion.longitud = data["longitud"]
	estacion.tiempo = data["tiempo"]
	estacion.enlace = data["enlace"]
	estacion.falla_energia = data["fallaEnergia"]
	estacion.abreviacion = data["abreviacion"]
	estacion.tipo_estacion = data["tipoEstacion"]
	estacion.conexiones = data["conexiones"]
	estacion.fallas = data["fallas"]
	estacion.tipo_poleo = data["tipoPoleo"]
	
	for signal_data in data["signals"]:
		var señal = Señal.new()
		señal.id_signal = signal_data["idSignal"]
		señal.id_estacion = signal_data["idEstacion"]
		señal.nombre = signal_data["nombre"]
		señal.valor = signal_data["valor"]
		señal.tipo_signal = signal_data["tipoSignal"]
		señal.ordinal = signal_data["ordinal"]
		señal.indice_imagen = signal_data["indiceImagen"]
		señal.dentro_limite = signal_data["dentroLimite"]
		señal.dentro_rango = signal_data["dentroRango"]
		señal.linea = signal_data["linea"]
		señal.habilitar = signal_data["habilitar"]
		
		if signal_data["semaforo"] != null:
			var semaforo = Semaforo.new()
			semaforo.id_signal = signal_data["semaforo"]["idSignal"]
			semaforo.normal = signal_data["semaforo"]["normal"]
			semaforo.preventivo = signal_data["semaforo"]["preventivo"]
			semaforo.critico = signal_data["semaforo"]["critico"]
			semaforo.altura = signal_data["semaforo"]["altura"]
			señal.semaforo = semaforo
		
		estacion.signals.append(señal)
	
	for linea_data in data["lineas"]:
		var linea = Linea.new()
		linea.id_linea = linea_data["idLinea"]
		linea.id_estacion = linea_data["idEstacion"]
		linea.nombre = linea_data["nombre"]
		estacion.lineas.append(linea)
	
	return estacion
