extends Node3D

@export var IdEstacion: int = 0;
@onready var labelFecha = $Sprite3D/FechaSitio
@onready var labelNivel = $Sprite3D/Nivel

var estacion: Estacion = null;
var nivel: Señal = null;

# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalData.connect("datos_actualizados", _on_datos_actualizados)
	refresh_data();


# Función que se llama cuando se actualizan los datos
func _on_datos_actualizados(estaciones: Array[Estacion]):
	if IdEstacion != 0:
		estacion = GlobalData.get_estacion(IdEstacion)  # Actualiza los datos del sitio con los nuevos datos
		for _signal: Señal in estacion.signals.values():
			if _signal.tipo_signal == 1:
				nivel = _signal;
				break;
			
	refresh_data();

func refresh_data():
	if estacion != null and nivel != null:
		labelFecha.text = "%s" % [GlobalUtils.formatear_fecha(estacion.tiempo)]
		labelNivel.text = "%s: %s m." % [nivel.nombre, nivel.valor if nivel.is_dentro_rango() else  "---" ]


func _on_EtiquetaClick(camera: Node, event: InputEvent, position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if(event is InputEventMouseButton  and event.double_click):
		var nivel_encontrado = SceneManager.load_scene(estacion.id_estacion)	
		if(nivel_encontrado):
			UIManager.mostrar_particular()	
			SceneManager.set_world_environment(SceneManager.TIPO_NIVEL.PARTICULAR)				
	
