extends Node

@export var sitio_scene: PackedScene
@onready var v_box_container: VBoxContainer = $ScrollContainer/VBoxContainer

#region TEXTURAS
@onready var textura1: Texture
@onready var textura2: Texture
@onready var lista_sitios_fondo: TextureRect = $lista_sitios_fondo
#endregion

# Lista para almacenar las instancias de los sitios
var sitio_instancias = []
var scroll_container: ScrollContainer

func set_textures():
	var _GlobalTextureResource = GlobalTextureResource.get_curret_resource()
	textura1 = _GlobalTextureResource.get_texture("lista_sitio_a")
	textura2 = _GlobalTextureResource.get_texture("lista_sitio_a")
	lista_sitios_fondo.texture = _GlobalTextureResource.get_texture("lista_fondo")


func _ready():
	scroll_container = $ScrollContainer
	# Obtener las estaciones al iniciar
	var estaciones: Array[Estacion] = GlobalData.get_data()
	# Conectarse a la señal datos_actualizados de DatosGlobales
	GlobalData.connect("datos_actualizados", _on_datos_actualizados)
	set_textures()
	actualizar_e_instanciar_sitios(estaciones)
	UIManager.scroll_container = scroll_container
	UIManager.vb_scroll = v_box_container

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
		sitio_instancias[i].set_datos(estaciones[i],i)
		# Alternar entre las dos texturas
		if i % 2 == 0:
			sitio_instancias[i].set_fondo(textura1)
		else:
			sitio_instancias[i].set_fondo(textura2)
