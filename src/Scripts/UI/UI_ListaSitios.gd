extends Node

@export var sitio_scene: PackedScene
@onready var v_box_container = $ScrollContainer/VBoxContainer

func _ready():
	# Conectarse a la señal datos_actualizados de DatosGlobales
	GlobalData.connect("datos_actualizados", _on_datos_actualizados)
	
	# Obtener las estaciones al iniciar
	var estaciones : Array[Estacion] = GlobalData.get_data()
	imprimir_datos_estaciones(estaciones)

func _on_datos_actualizados(estaciones : Array[Estacion]):
	imprimir_datos_estaciones(estaciones)
	actualizar_e_instanciar_sitios(estaciones)

func imprimir_datos_estaciones(estaciones : Array[Estacion]):
	for estacion in estaciones:							
		print("")
		print("********************")
		print("Estación:") 
		print("  ID:", estacion.id_estacion)
		print("  Nombre:", estacion.nombre)
		print("  Latitud:", estacion.latitud)
		print("  Longitud:", estacion.longitud)
		print("  Tiempo:", estacion.tiempo)
		print("  Enlace:", estacion.enlace)
		print("  Falla Energía:", estacion.falla_energia)
		print("  Abreviación:", estacion.abreviacion)
		print("  Tipo Estación:", estacion.tipo_estacion)
		print("  Conexiones:", estacion.conexiones)
		print("  Fallas:", estacion.fallas)
		print("  Tipo Poleo:", estacion.tipo_poleo)
		for señal in estacion.signals:				
			print("    Señal:")
			print("      ID:", señal.id_signal)
			print("      Nombre:", señal.nombre)
			print("      Valor:", señal.valor)
			print("      Tipo Señal:", señal.tipo_signal)
			if señal.semaforo != null:
				print("      Semáforo:")
				print("        Normal:", señal.semaforo.normal)
				print("        Preventivo:", señal.semaforo.preventivo)
				print("        Crítico:", señal.semaforo.critico)
				print("        Altura:", señal.semaforo.altura)
		for linea in estacion.lineas:
			print("    Línea:")
			print("      ID:", linea.id_linea)
			print("      Nombre:", linea.nombre)
		print("********************")

func actualizar_e_instanciar_sitios(estaciones: Array[Estacion]):
	for estacion in estaciones:
		var sitio_instance = sitio_scene.instantiate()
		v_box_container.add_child(sitio_instance)
		sitio_instance.name = "Sitio"
		sitio_instance.set_datos(estacion)
		

