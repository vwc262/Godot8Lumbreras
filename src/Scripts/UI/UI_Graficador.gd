extends Node

@onready var btn_colapsar_lista = $Panel/VBoxContainer/footer_container/VBoxContainer/botones_container/HBoxContainer/btn_colapsar_lista
@onready var datos_graficador_container = $Panel/VBoxContainer/footer_container/VBoxContainer/datos_graficador_container

@onready var dia_selector = $Panel/VBoxContainer/footer_container/VBoxContainer/datos_graficador_container/VBoxContainer/fecha_container/HBoxContainer/HBoxContainer/dia_container/dia_selector
@onready var mes_selector = $Panel/VBoxContainer/footer_container/VBoxContainer/datos_graficador_container/VBoxContainer/fecha_container/HBoxContainer/HBoxContainer/mes_container/mes_selector
@onready var año_selector = $Panel/VBoxContainer/footer_container/VBoxContainer/datos_graficador_container/VBoxContainer/fecha_container/HBoxContainer/HBoxContainer/año_container/año_selector

@onready var lbl_nombre_sitio = $Panel/VBoxContainer/header_container/lbl_nombre_sitio

#regions TEXTURAS
@onready var header_fondo: TextureRect = $Panel/VBoxContainer/header_container/header_fondo
@onready var datos_graficador_container_fondo: TextureRect = $Panel/VBoxContainer/footer_container/VBoxContainer/datos_graficador_container/datos_graficador_container_fondo
@onready var fondo_selector_1: TextureRect = $Panel/VBoxContainer/footer_container/VBoxContainer/datos_graficador_container/VBoxContainer/fecha_container/HBoxContainer/HBoxContainer/dia_container/fondo_selector
@onready var fondo_selector_2: TextureRect = $Panel/VBoxContainer/footer_container/VBoxContainer/datos_graficador_container/VBoxContainer/fecha_container/HBoxContainer/HBoxContainer/mes_container/fondo_selector
@onready var fondo_selector_3: TextureRect = $"Panel/VBoxContainer/footer_container/VBoxContainer/datos_graficador_container/VBoxContainer/fecha_container/HBoxContainer/HBoxContainer/año_container/fondo_selector"
@onready var hora_fondo: TextureRect = $Panel/VBoxContainer/footer_container/VBoxContainer/datos_graficador_container/VBoxContainer/hora_container/hora_fondo
@onready var btn_icono_izq: TextureRect = $Panel/VBoxContainer/footer_container/VBoxContainer/botones_container/HBoxContainer/btn_perfil/btn_icono_izq
@onready var btn_icono_mid: TextureRect = $Panel/VBoxContainer/footer_container/VBoxContainer/botones_container/HBoxContainer/btn_colapsar_lista/btn_icono_mid
@onready var btn_icono_der: TextureRect = $Panel/VBoxContainer/footer_container/VBoxContainer/botones_container/HBoxContainer/btn_particular/btn_icono_der
@onready var original_icono: Texture
@onready var new_icono: Texture
#endregion

var lista_colapsada = false  # Estado inicial de la lista

func _on_btn_colapsar_lista_pressed():
	if lista_colapsada:
		descolapsar_lista()
		btn_icono_mid.texture = original_icono
	else:
		colapsar_lista()
		btn_icono_mid.texture = new_icono
	lista_colapsada = !lista_colapsada

func colapsar_lista():
	var tween = TweenManager.init_tween(_on_finish_tween)
	TweenManager.tween_animacion(tween, datos_graficador_container, "custom_minimum_size:y", 0, 0.3)

func descolapsar_lista():
	var tween = TweenManager.init_tween(_on_finish_tween)
	TweenManager.tween_animacion(tween, datos_graficador_container, "custom_minimum_size:y", 200, 0.3)

func _on_finish_tween():
	pass

func set_textures():
	var _GlobalTextureResource = GlobalTextureResource.get_curret_resource()
	header_fondo.texture = _GlobalTextureResource.get_texture("header")
	datos_graficador_container_fondo.texture = _GlobalTextureResource.get_texture("detalles_fondo")
	fondo_selector_1.texture = _GlobalTextureResource.get_texture("lista_valor_contenedor")
	fondo_selector_2.texture = _GlobalTextureResource.get_texture("lista_valor_contenedor")
	fondo_selector_3.texture = _GlobalTextureResource.get_texture("lista_valor_contenedor")
	hora_fondo.texture = _GlobalTextureResource.get_texture("lista_valor_contenedor")
	btn_icono_izq.texture = _GlobalTextureResource.get_texture("boton_cambio_scene_izq")
	btn_icono_mid.texture = _GlobalTextureResource.get_texture("boton_hide_lista")
	btn_icono_der.texture = _GlobalTextureResource.get_texture("boton_cambio_scene_der")
	original_icono = _GlobalTextureResource.get_texture("boton_hide_lista")
	new_icono = _GlobalTextureResource.get_texture("boton_show_lista")

func _ready():
	set_textures()
	SceneManager.add_scene(SceneManager.idSceneGraficador, self)
	dia_selector.connect("focus_entered", _on_dia_selector_focus_entered)
	mes_selector.connect("focus_entered", _on_mes_selector_focus_entered)
	año_selector.connect("focus_entered", _on_año_selector_focus_entered)

func _on_dia_selector_focus_entered():
	cargar_dias()

func _on_mes_selector_focus_entered():
	cargar_meses()

func _on_año_selector_focus_entered():
	cargar_años()

func cargar_dias():
	dia_selector.clear()
	var mes_seleccionado = mes_selector.get_selected_id()
	var año_seleccionado = int(año_selector.get_item_text(año_selector.get_selected_id()))
	
	var dias_en_mes = obtener_dias_en_mes(mes_seleccionado, año_seleccionado)
	
	for i in range(1, dias_en_mes + 1):
		dia_selector.add_item(str(i))

func cargar_meses():
	mes_selector.clear()
	var meses = ["Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"]
	for mes in meses:
		mes_selector.add_item(mes)

func cargar_años():
	año_selector.clear()
	var año_actual = 2024  # Puedes cambiar esto por el año actual si es necesario
	for i in range(2020, año_actual + 1):  # Carga años desde 2020 hasta el año actual
		año_selector.add_item(str(i))

func obtener_dias_en_mes(mes: int, año: int) -> int:
	match mes:
		0, 2, 4, 6, 7, 9, 11:  # Enero, Marzo, Mayo, Julio, Agosto, Octubre, Diciembre (31 días)
			return 31
		3, 5, 8, 10:  # Abril, Junio, Septiembre, Noviembre (30 días)
			return 30
		1:  # Febrero
			if es_bisiesto(año):
				return 29
			else:
				return 28
		_:
			return 30  # Valor por defecto

func es_bisiesto(año: int) -> bool:
	return (año % 4 == 0 and año % 100 != 0) or (año % 400 == 0)


func _on_btn_perfil_pressed():
	SceneManager.scroll_scene(SceneManager.TIPO_NIVEL.PERFIL, SceneManager.idScenePerfil)

func _on_btn_particular_pressed():
	SceneManager.scroll_scene(SceneManager.TIPO_NIVEL.PARTICULAR, NavigationManager.last_selected)


func _on_visibility_changed():
	if self.visible and NavigationManager.last_selected != 0:
		var datos_estacion = GlobalData.get_estacion(NavigationManager.last_selected)
		lbl_nombre_sitio.text = datos_estacion.nombre
