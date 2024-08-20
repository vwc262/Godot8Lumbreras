extends Node3D

@export var IdEstacion: int = 0;
@onready var labelNivel = $Sprite3D/Nivel
@onready var canvas_container = $Sprite3D

var estacion: Estacion = null;
var segnal: Señal = null;
var semaforo: Semaforo = null;

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
			if _signal.tipo_signal == 3:
				segnal = _signal;
				if semaforo == null:
					semaforo = segnal.semaforo
				break;
	refresh_data();

func refresh_data():
	if estacion != null and segnal != null:
		labelNivel.text = segnal.nombre + ": " + str(segnal.valor) + " m." if segnal.is_dentro_rango() else "N.D."
		labelNivel.text = "G1: %s" % [labelNivel.text]


func _on_EtiquetaClick(_camera: Node, event: InputEvent, _position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if(event is InputEventMouseButton  and event.double_click):
		SceneManager.scroll_scene(SceneManager.TIPO_NIVEL.PARTICULAR,estacion.id_estacion)	
