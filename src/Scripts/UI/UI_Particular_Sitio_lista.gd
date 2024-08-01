extends Control

@onready var lbl_nombre_sitio = $sitio_container/HBoxContainer/VBoxContainer/lbl_nombre_sitio
@onready var lbl_fecha_sitio = $sitio_container/HBoxContainer/VBoxContainer/lbl_fecha_sitio
@onready var texture_enlace = $sitio_container/HBoxContainer/sitio_enlace_container/texture_enlace
@onready var sitio_fondo_seleccionado = $sitio_container/sitio_fondo_seleccionado
@onready var btn_lista_sitio = $sitio_container/btn_lista_sitio
@onready var sitio_fondo = $sitio_container/sitio_fondo  # Añadir referencia al fondo

@export var texture_online: Texture2D
@export var texture_offline: Texture2D

var id_Estacion : int = 0

func _ready():
	btn_lista_sitio.connect("pressed", _on_btn_lista_sitio_pressed)

# Función para establecer los datos del sitio
func set_datos(sitio: Estacion):
	id_Estacion = sitio.id_estacion
	# Actualiza el nombre del sitio
	lbl_nombre_sitio.text = sitio.nombre
	
	# Formatea y actualiza la fecha del sitio
	lbl_fecha_sitio.text = GlobalUtils.formatear_fecha(sitio.tiempo)
	
	# Cambia la textura en función del estado del enlace
	if sitio.enlace in [1, 2, 3]:
		texture_enlace.texture = texture_online
	else:
		texture_enlace.texture = texture_offline

func _on_btn_lista_sitio_pressed():
	if UIManager.is_sitio_selected(self):
		print("sitio seleccionado")
	else:
		SceneManager.load_scene(id_Estacion)
		UIManager.seleccionar_lista_sitio(self)
		NavigationManager.set_lastid_selected(id_Estacion)
		UIManager.reprint_ui_particular()

func seleccionar():
	sitio_fondo_seleccionado.visible = true

func deseleccionar():
	sitio_fondo_seleccionado.visible = false

func set_fondo(texture: Texture2D):
	sitio_fondo.texture = texture
