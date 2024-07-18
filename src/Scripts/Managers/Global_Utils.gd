# Utils.gd
extends Node
class_name Utils

# Función para formatear la fecha
func formatear_fecha(fecha_string: String) -> String:
	# Dividir la fecha y hora
	var partes = fecha_string.split("T")
	if partes.size() != 2:
		return fecha_string # Devolver la fecha original si no tiene el formato esperado

	var fecha = partes[0]
	var hora = partes[1]

	# Formatear fecha
	var fecha_partes = fecha.split("-")
	if fecha_partes.size() != 3:
		return fecha_string # Devolver la fecha original si no tiene el formato esperado

	var año = fecha_partes[0]
	var mes = fecha_partes[1]
	var dia = fecha_partes[2]

	# Formatear hora
	var hora_partes = hora.split(":")
	if hora_partes.size() < 2:
		return fecha_string # Devolver la fecha original si no tiene el formato esperado

	var horas = hora_partes[0]
	var minutos = hora_partes[1]

	# Construir la fecha formateada
	var fecha_formateada = horas + ":" + minutos + "hrs, " + dia + "/" + mes + "/" + año
	return fecha_formateada
