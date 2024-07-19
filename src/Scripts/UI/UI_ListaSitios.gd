extends Node

@export var sitio_scene: PackedScene
@export var textura1: Texture
@export var textura2: Texture
@onready var v_box_container = $ScrollContainer/VBoxContainer

# Lista para almacenar las instancias de los sitios
var sitio_instancias = []

func _ready():
	# Conectarse a la señal datos_actualizados de DatosGlobales
	GlobalData.connect("datos_actualizados", _on_datos_actualizados)
	
	# Obtener las estaciones al iniciar
	var estaciones: Array[Estacion] = GlobalData.get_data()
	actualizar_e_instanciar_sitios(estaciones)

func _on_datos_actualizados(estaciones: Array[Estacion]):
	actualizar_e_instanciar_sitios(estaciones)
	
func actualizar_e_instanciar_sitios(estaciones: Array[Estacion]):
	# Asegurarse de que hay suficientes instancias
	while sitio_instancias.size() < estaciones.size():
		var sitio_instance = sitio_scene.instantiate()
		v_box_container.add_child(sitio_instance)
		sitio_instancias.append(sitio_instance)

	# Actualizar las instancias existentes con nuevos datos
	for i in range(estaciones.size()):
		sitio_instancias[i].set_datos(estaciones[i])
		# Alternar entre las dos texturas
		if i % 2 == 0:
			sitio_instancias[i].set_fondo(textura1)
		else:
			sitio_instancias[i].set_fondo(textura2)
