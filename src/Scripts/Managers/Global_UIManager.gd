# UIManager.gd
extends Node

signal sitio_seleccionado  # Señal emitida cuando se selecciona un sitio
signal mostrar_world  # Señal emitida para mostrar el world

var lista_sitios: Array[Control] = []  # Lista de sitios (Controles) en la UI
var current_selected_site = null  # Sitio actualmente seleccionado

var ui_particular: Node = null  # Referencia al nodo UI particular

# Función para seleccionar un sitio
func seleccionar_sitio(sitio):
	if current_selected_site == sitio:
		sitio.deseleccionar()  # Deseleccionar si el sitio ya está seleccionado
		current_selected_site = null
	else:
		if current_selected_site != null:
			current_selected_site.deseleccionar()  # Deseleccionar el sitio anterior
		current_selected_site = sitio
		sitio.seleccionar()  # Seleccionar el nuevo sitio
		emit_signal("sitio_seleccionado", sitio)  # Emitir señal de sitio seleccionado

# Función para deseleccionar todos los sitios
func deselect_all_sitios():
	current_selected_site = null
	for sitio in lista_sitios:
		sitio.deseleccionar()  # Deseleccionar cada sitio en la lista

# Función para agregar un sitio a la lista de sitios
func add_sitio(sitio):
	if sitio not in lista_sitios:
		lista_sitios.append(sitio)  # Agregar sitio a la lista si no está ya en ella

# Función para establecer la referencia al nodo UI particular
func set_ui_particular(particular_node: Node):
	ui_particular = particular_node

# Función para mostrar el UI particular
func mostrar_particular():
	if ui_particular != null:
		ui_particular.visible = true  # Hacer visible el UI particular
		ui_particular.init_particular(true)  # Inicializar el UI particular

# Función para ocultar el UI particular
func ocultar_particular():
	if ui_particular != null:
		ui_particular.visible = false  # Hacer invisible el UI particular
		emit_signal("mostrar_world")  # Emitir señal para mostrar el world
