# UIManager.gd
extends Node

signal sitio_seleccionado

var lista_sitios: Array[Control] = []
var current_selected_site = null

var ui_particular: Node = null

func seleccionar_sitio(sitio):
	if current_selected_site == sitio:
		sitio.deseleccionar()
		current_selected_site = null
	else:
		if current_selected_site != null:
			current_selected_site.deseleccionar()
		current_selected_site = sitio
		sitio.seleccionar()
		emit_signal("sitio_seleccionado", sitio)

func deselect_all_sitios():
	current_selected_site = null
	for sitio in lista_sitios:
		sitio.deseleccionar()

func add_sitio(sitio):
	if sitio not in lista_sitios:
		lista_sitios.append(sitio)

func set_ui_particular(particular_node: Node):
	ui_particular = particular_node

func mostrar_particular():
	if ui_particular != null:
		ui_particular.visible = true
		ui_particular.init_particular(true)

func ocultar_particular():
	if ui_particular != null:
		ui_particular.visible = false
