# DataStore.gd
extends Node

# Variable para almacenar los datos
var data = {}

# Función para actualizar los datos
func set_data(new_data):
	data = new_data

# Función para obtener los datos
func get_data():
	return data
