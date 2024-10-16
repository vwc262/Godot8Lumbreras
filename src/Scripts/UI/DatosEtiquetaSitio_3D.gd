extends Node3D

@export var IdEstacion: int = 0;
@onready var labelFecha = $Sprite3D/FechaSitio
@onready var labelNivel = $Sprite3D/Nivel
@onready var labelNombre = $Sprite3D/NombreSitio
@onready var canvas_container = $Sprite3D

@export var base_color: Color = Color(27, 115, 202, 255);
@export var color_rango: Color = Color(112, 112, 112, 255);

const online_texture = preload("res://Recursos/UI/img/cutzamala_v_final/Panel_Nivel_a.png");
const offline_texture = preload("res://Recursos/UI/img/cutzamala_v_final/Panel_Nivel_b.png");

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
				#nivel = _signal;
				if semaforo == null:
					semaforo = _signal.semaforo				
			if _signal.tipo_signal == 3:
				nivel = _signal	
				break;
	refresh_data();

func refresh_data():
	if estacion != null and nivel != null:
		labelNombre.text = "%s" % [estacion.nombre]
		labelFecha.text = "%s" % [GlobalUtils.formatear_fecha(estacion.tiempo)]
		labelNivel.text = nivel.nombre + ": " + str(nivel.valor) + " " + nivel.get_unities() if nivel.is_dentro_rango() else "N.D."
		
		progressbar_material.set_shader_parameter("color", nivel.get_color_barra_vida() if nivel.is_dentro_rango() else color_rango)
		var offset_parameter = 1.0 if !nivel.is_dentro_rango() else remap(nivel.valor, 0.0, semaforo.critico, 0.01, 1.0)
		#progressbar_material.set_shader_parameter("offset", offset_parameter)
		tweenBlur = TweenManager.init_tween(OnTweenFinished)
		tweenBlur.tween_property(progressbar_material, "shader_parameter/offset", offset_parameter, 0.2)
		print(estacion.nombre , " en linea " , estacion.is_estacion_en_linea())
		canvas_container.texture = online_texture if estacion.is_estacion_en_linea()  else online_texture
		canvas_material.set("shader_parameter/texture_albedo", online_texture if estacion.is_estacion_en_linea() else offline_texture)
