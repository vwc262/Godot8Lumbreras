extends Node3D

@export var IdEstacion: int = 0;
@onready var labelFecha = $Sprite3D/FechaSitio
@onready var labelNivel = $Sprite3D/Nivel
@onready var labelNombre = $Sprite3D/NombreSitio
@onready var canvas_container = $Sprite3D

@export var base_color: Color = Color(27, 115, 202, 255);
@export var color_rango: Color = Color(112, 112, 112, 255);

const online_texture = preload("res://Recursos/UI/3D/Panel_Nivel_a.png");
const offline_texture = preload("res://Recursos/UI/3D/Panel_Nivel_b.png");

var estacion: Estacion = null;
var nivel: Señal = null;
var semaforo: Semaforo = null;

@onready var progressbar_material:Material = $Sprite3D/Progressbar3D.material_override
@onready var canvas_material:Material = $Sprite3D.material_override
var tweenBlur;

# Called when the node enters the scene tree for the first time.
func _ready():		
	GlobalData.connect("datos_actualizados", _on_datos_actualizados)
	refresh_data();

func OnTweenFinished():
	pass

# Función que se llama cuando se actualizan los datos
func _on_datos_actualizados(_estaciones: Array[Estacion]):
	if IdEstacion != 0:
		estacion = GlobalData.get_estacion(IdEstacion)  # Actualiza los datos del sitio con los nuevos datos
		for _signal: Señal in estacion.signals.values():
			if _signal.tipo_signal == 1:
				nivel = _signal;
				if semaforo == null:
					semaforo = nivel.semaforo
				break;
	refresh_data();

func refresh_data():
	if estacion != null and nivel != null:
		labelNombre.text = "%s" % [estacion.nombre]
		labelFecha.text = "%s" % [GlobalUtils.formatear_fecha(estacion.tiempo)]
		labelNivel.text = nivel.nombre + ": " + str(nivel.valor) + " m." if nivel.is_dentro_rango() else "N.D."
		
		progressbar_material.set_shader_parameter("color", base_color if nivel.dentro_rango else color_rango)
		var offset_parameter = 1.0 if nivel.dentro_rango else remap(nivel.valor, 0.0, semaforo.critico, 0.01, 1.0)
		#progressbar_material.set_shader_parameter("offset", offset_parameter)
		tweenBlur = TweenManager.init_tween(OnTweenFinished)
		tweenBlur.tween_property(progressbar_material, "shader_parameter/offset", offset_parameter, 0.2)
		
		canvas_container.texture = online_texture if estacion.enlace != 0 else offline_texture
		canvas_material.set("shader_parameter/texture_albedo", online_texture if estacion.enlace != 0 else offline_texture)

func _on_EtiquetaClick(_camera: Node, event: InputEvent, _position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if(event is InputEventMouseButton  and event.double_click):
		SceneManager.scroll_scene(SceneManager.TIPO_NIVEL.PARTICULAR,estacion.id_estacion)		
