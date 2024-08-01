# UIManager.gd
extends Node

signal sitio_seleccionado
signal mostrar_world  # Señal para mostrar el world

var lista_sitios: Array[Control] = []
var current_selected_site = null
var current_lista_site = null  # Nuevo: sitio seleccionado en la lista

var ui_particular: Node = null
var popUpWindow : Node = null


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

# Método para seleccionar un sitio de lista
func seleccionar_lista_sitio(sitio):	
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

# Método para verificar si un sitio está seleccionado
func is_sitio_selected(sitio) -> bool:
	return current_selected_site == sitio
	
func reprint_ui_particular():
	ui_particular.reprint()	
	
func set_popUp_window(popUpRef):
	popUpWindow	= popUpRef
		
func seleccionar_sitio_id(id_estacion):
	for sitio in lista_sitios:
		if sitio.id_estacion == id_estacion:
			seleccionar_sitio(sitio)
			
	
