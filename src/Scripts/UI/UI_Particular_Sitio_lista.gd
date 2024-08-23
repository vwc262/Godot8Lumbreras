extends Control

@onready var lbl_nombre_sitio = $sitio_container/HBoxContainer/VBoxContainer/lbl_nombre_sitio
@onready var lbl_fecha_sitio = $sitio_container/HBoxContainer/VBoxContainer/lbl_fecha_sitio
@onready var texture_enlace = $sitio_container/HBoxContainer/sitio_enlace_container/texture_enlace
@onready var btn_lista_sitio = $sitio_container/btn_lista_sitio

@onready var texture_online: Texture
@onready var texture_offline: Texture

@onready var sitio_fondo: TextureRect = $sitio_container/sitio_fondo

var id_Estacion : int = 0

func set_textures():
	var _GlobalTextureResource = GlobalTextureResource.get_curret_resource()
	sitio_fondo.texture = _GlobalTextureResource.get_texture("header_lista_b")
	texture_online = _GlobalTextureResource.get_texture("header_estado_online")
	texture_offline = _GlobalTextureResource.get_texture("header_estado_offline")

func _ready():
	set_textures()
	btn_lista_sitio.connect("pressed", _on_btn_lista_sitio_pressed)

# Función para establecer los datos del sitio
func set_datos(sitio: Estacion):
	id_Estacion = sitio.id_estacion
	# Actualiza el nombre del sitio
	lbl_nombre_sitio.text = sitio.nombre
	
	# Formatea y actualiza la fecha del sitio
	lbl_fecha_sitio.text = GlobalUtils.formatear_fecha(sitio.tiempo)
	
	# Cambia la textura en función del estado del enlace
	if sitio.is_estacion_en_linea():
		texture_enlace.texture = texture_online
	else:
		texture_enlace.texture = texture_offline

func _on_btn_lista_sitio_pressed():
	if UIManager.is_sitio_selected(self):
		print("sitio seleccionado")
	else:
		SceneManager.scroll_scene(SceneManager.TIPO_NIVEL.PARTICULAR,id_Estacion)

func set_fondo(texture: Texture2D):
	sitio_fondo.texture = texture
