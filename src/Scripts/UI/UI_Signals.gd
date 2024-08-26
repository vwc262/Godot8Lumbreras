extends Control

class_name SegnalLista

@onready var progress_bar: ProgressBar = $main_container/HBoxContainer/VBoxContainer/nivel_container/nivel_progressbar_container/VBoxContainer/ProgressBar

@onready var lbl_nivel_nombre: Label = $main_container/HBoxContainer/VBoxContainer/nivel_container/nivel_nombre_container/HBoxContainer/lbl_nivel_nombre
@onready var lbl_nivel_valor_min: Label = $main_container/HBoxContainer/VBoxContainer/nivel_container/nivel_progressbar_container/VBoxContainer/HBoxContainer/lbl_nivel_valor_min
@onready var lbl_nivel_valor_max: Label = $main_container/HBoxContainer/VBoxContainer/nivel_container/nivel_progressbar_container/VBoxContainer/HBoxContainer/lbl_nivel_valor_max
@onready var lbl_presion_nombre: Label = $main_container/HBoxContainer/VBoxContainer/presion_container/presion_container/HBoxContainer/lbl_presion_nombre
@onready var lbl_gasto_nombre: Label = $main_container/HBoxContainer/VBoxContainer/gasto_container/gasto_container/HBoxContainer2/lbl_gasto_nombre
@onready var lbl_totalizado_nombre: Label = $main_container/HBoxContainer/VBoxContainer/totalizado_container/lbl_totalizado_nombre
@onready var lbl_totalizado_valor: Label = $main_container/HBoxContainer/VBoxContainer/totalizado_container/totalizado_valor_container/lbl_totalizado_valor
@onready var lbl_nivel_valor: Label = $main_container/HBoxContainer/VBoxContainer/nivel_container/nivel_valor_container/lbl_nivel_valor
@onready var presion_valor: Label = $main_container/HBoxContainer/VBoxContainer/presion_container/presion_container/HBoxContainer/presion_valor_container/presion_valor
@onready var gasto_valor: Label = $main_container/HBoxContainer/VBoxContainer/gasto_container/gasto_container/HBoxContainer2/gasto_valor_container/gasto_valor

#region TEXTURAS
@onready var texture_punto_nivel: TextureRect = $main_container/HBoxContainer/VBoxContainer/nivel_container/nivel_nombre_container/HBoxContainer/texture_punto_nivel
@onready var punto_nivel: TextureRect =  $main_container/HBoxContainer/VBoxContainer/nivel_container/nivel_nombre_container/HBoxContainer/texture_punto_nivel
@onready var valor_nivel: TextureRect =  $main_container/HBoxContainer/VBoxContainer/nivel_container/nivel_valor_container/texture_valor_nivel
@onready var punto_presion: TextureRect =  $main_container/HBoxContainer/VBoxContainer/presion_container/presion_container/HBoxContainer/texture_punto_presion
@onready var valor_presion: TextureRect =  $main_container/HBoxContainer/VBoxContainer/presion_container/presion_container/HBoxContainer/presion_valor_container/texture_valor_presion
@onready var punto_gasto: TextureRect =  $main_container/HBoxContainer/VBoxContainer/gasto_container/gasto_container/HBoxContainer2/texture_punto_gasto
@onready var valor_gasto: TextureRect =  $main_container/HBoxContainer/VBoxContainer/gasto_container/gasto_container/HBoxContainer2/gasto_valor_container/texture_valor_gasto
@onready var punto_totalizado: TextureRect =  $main_container/HBoxContainer/VBoxContainer/totalizado_container/texture_punto_totalizado
@onready var valor_totalizado: TextureRect =  $main_container/HBoxContainer/VBoxContainer/totalizado_container/totalizado_valor_container/texture_valor_totalizado
@onready var bnt_graficador_fondo: TextureRect =  $main_container/HBoxContainer/VBoxContainer/botones_container/btn_graficador/bnt_graficador_fondo
@onready var bnt_particular_fondo: TextureRect =  $main_container/HBoxContainer/VBoxContainer/botones_container/btn_particular/bnt_particular_fondo
@onready var fondo_se_al: TextureRect = $"main_container/fondo_señal"

#endregion


# Referencia a la señal que se va a mostrar
var signal_ref: Array[Señal] = []
var id_estacion: int
var set_maximos=false

# Diccioario para las unidades de tipo de señal
var unidades = {
	1: "m",
	2: "kg/cm²",
	3: "l/s",
	4: "m³"
}

func set_textures():
	var _GlobalTextureResource = GlobalTextureResource.get_curret_resource()
	punto_nivel.texture =  _GlobalTextureResource.get_texture("punto_listas")
	punto_presion.texture =  _GlobalTextureResource.get_texture("punto_listas")
	punto_gasto.texture =  _GlobalTextureResource.get_texture("punto_listas")
	punto_totalizado.texture =  _GlobalTextureResource.get_texture("punto_listas")
	valor_nivel.texture =  _GlobalTextureResource.get_texture("lista_valor_contenedor")
	valor_presion.texture =  _GlobalTextureResource.get_texture("lista_valor_contenedor")
	valor_gasto.texture =  _GlobalTextureResource.get_texture("lista_valor_contenedor")
	valor_totalizado.texture =  _GlobalTextureResource.get_texture("lista_valor_contenedor")
	bnt_graficador_fondo.texture =  _GlobalTextureResource.get_texture("boton_cambio_scene_izq")
	bnt_particular_fondo.texture =  _GlobalTextureResource.get_texture("boton_cambio_scene_der")
	fondo_se_al.texture = _GlobalTextureResource.get_texture("fondo_senales")

func _ready() -> void:
	set_textures()

	
func set_maximos_minimos(senal:Señal):
	if !set_maximos:
		progress_bar.max_value = senal.semaforo["critico"]
		progress_bar.min_value = 0
		
	set_maximos = true	
	

# Función para recibir y establecer los datos de la señal
func set_datos(estacion: Estacion):
	id_estacion = estacion.id_estacion
	signal_ref.assign(estacion.signals.values())
	call_deferred("actualizar_datos")

func actualizar_datos():
	var fuera_de_rango = "N.D."
	for _signal in signal_ref:
		var unidad = unidades.get(_signal.tipo_signal, "")
		
		if _signal.tipo_signal == 1:
			lbl_nivel_nombre.text = _signal.nombre
			lbl_nivel_valor.text = str(_signal.valor) + " " + unidad if _signal.is_dentro_rango() else fuera_de_rango
		elif _signal.tipo_signal == 2:
			lbl_presion_nombre.text = _signal.nombre
			presion_valor.text = str(_signal.valor) + " " + unidad if _signal.is_dentro_rango() else fuera_de_rango
		elif _signal.tipo_signal == 3:
			lbl_gasto_nombre.text = _signal.nombre
			gasto_valor.text = str(_signal.valor) + " " + unidad if _signal.is_dentro_rango() else fuera_de_rango
		elif _signal.tipo_signal == 4:
			lbl_totalizado_nombre.text = _signal.nombre
			lbl_totalizado_valor.text = str(_signal.valor) + " " + unidad if _signal.is_dentro_rango() else fuera_de_rango
		
		if _signal.semaforo != null:
			set_progress_bar(_signal, unidad)

				
# Función para establecer la barra de progreso
func set_progress_bar(_signal: Señal, unidad):
	set_maximos_minimos(_signal)
	##Asegurarse de que el valor mínimo visible siempre esté presente	
	var display_value =  clamp(_signal.valor,.18,progress_bar.max_value)	#
	lbl_nivel_valor_min.text = "min : " + str(_signal.semaforo["normal"]) + " " + unidad
	lbl_nivel_valor_max.text = "max : " + str(_signal.semaforo["critico"]) + " " + unidad
#
	# Cambiar el color de la barra de progreso según el valor de la señal
	if !_signal.is_dentro_rango():
		progress_bar.modulate = Color(.7, .7, .7) # Gris
	else:	
		if _signal.valor > _signal.semaforo.normal and _signal.valor <= _signal.semaforo.preventivo:
			progress_bar.modulate = Color(1, 1, 0) # Amarillo
		elif _signal.valor > _signal.semaforo.preventivo:
			progress_bar.modulate = Color(1, 0, 0) # Rojo
		else:
			progress_bar.modulate = Color(0, 1, 0) # Verde

	#Usar Tween para animar la barra de progreso
	var tween = TweenManager.init_tween(_on_tween_finished.bind(display_value))
	tween.tween_property(progress_bar, "value",display_value if _signal.is_dentro_rango() else progress_bar.max_value , .2)

	
func _on_tween_finished(_valor_a_poner): 
	pass

# Función general para manejar la lógica compartida de los botones
func manejar_btn_presionado(_mostrar_graficador: bool):
	UIManager.seleccionar_sitio_id(id_estacion)
	
	if UIManager.current_selected_site:
		SceneManager.scroll_scene(SceneManager.TIPO_NIVEL.PARTICULAR,id_estacion)
		NavigationManager.set_lastid_selected(id_estacion)
		UIManager.mostrar_particular()

# Llamada al presionar el botón de graficador
func _on_btn_graficador_pressed():
	#manejar_btn_presionado(true)
	NavigationManager.set_lastid_selected(id_estacion)
	SceneManager.scroll_scene(SceneManager.TIPO_NIVEL.GRAFICADOR,SceneManager.idSceneGraficador)

# Llamada al presionar el botón de particular
func _on_btn_particular_pressed():
	manejar_btn_presionado(false)

# Función para actualizar el texto del botón de particular/graficador
func _actualizar_texto_boton_particular():
	
	if UIManager.is_graficador_visible():
		UIManager.btn_graficador.text = "Particular"
	else:
		UIManager.btn_graficador.text = "Graficador"
