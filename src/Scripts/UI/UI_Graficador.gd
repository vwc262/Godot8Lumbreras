extends Node

@onready var btn_colapsar_lista = $Panel/VBoxContainer/footer_container/VBoxContainer/botones_container/HBoxContainer/btn_colapsar_lista
@onready var datos_graficador_container = $Panel/VBoxContainer/footer_container/VBoxContainer/datos_graficador_container

@onready var dia_selector = $Panel/VBoxContainer/footer_container/VBoxContainer/datos_graficador_container/VBoxContainer/fecha_container/HBoxContainer/HBoxContainer/dia_container/dia_selector
@onready var mes_selector = $Panel/VBoxContainer/footer_container/VBoxContainer/datos_graficador_container/VBoxContainer/fecha_container/HBoxContainer/HBoxContainer/mes_container/mes_selector
@onready var año_selector = $Panel/VBoxContainer/footer_container/VBoxContainer/datos_graficador_container/VBoxContainer/fecha_container/HBoxContainer/HBoxContainer/año_container/año_selector

@onready var lbl_nombre_sitio = $Panel/VBoxContainer/header_container/lbl_nombre_sitio

var lista_colapsada = false  # Estado inicial de la lista

func _ready():
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
