extends Node


#region Variables
var scenes = {}
var idScenePerfil = 100
var world_environment : WorldEnvironment
var perfil_environment: Environment
var particular_environment: Environment
#La cantidad de ventanas que va a tener el viewport para scroll
var total_windows : int = 3

var scroll_reference : ScrollContainer = null
var viewport_size_x = 0

enum TIPO_NIVEL {GRAFICADOR,PERFIL,PARTICULAR,}
#endregion


#region Funciones
#Almacena las referencias de los particulares
func add_scene(idSceneKey:int,scene:Node3D):
	scenes[idSceneKey] = scene
	pass
	
func unload_scenes():
	for scene in scenes.values():
		scene.visible = false
	pass

func load_scene(idSceneKey:int):
	var nivel_encontrado = scenes.has(idSceneKey)
	if nivel_encontrado:
		unload_scenes()
		scenes[idSceneKey].visible = true	
	else:
		var estacion : Estacion = GlobalData.get_estacion(idSceneKey)
		UIManager.popUpWindow.showPopUp( estacion.nombre + " en construcción")
	return nivel_encontrado	

func set_viewport_size_x(viewportsizeX):
	viewport_size_x = viewportsizeX

func get_scroll_step() -> float:	
	return viewport_size_x / total_windows	

func scroll_scene(tipo_nivel:TIPO_NIVEL):
	var step = get_scroll_step()
	var scroll_amount : int = step * tipo_nivel
	scroll_reference.scroll_horizontal = scroll_amount
	
	
func set_initial_window():
	scroll_scene(TIPO_NIVEL.PERFIL)	
	
	
			

func set_scroll_reference(scroll:ScrollContainer):
	scroll_reference = scroll		

func init_wolrd_environment_reference(world_environment_reference:WorldEnvironment):
	world_environment = world_environment_reference

func load_environments(perfil_environment_ref:Environment,particular_environment_ref:Environment):
	perfil_environment = perfil_environment_ref
	particular_environment = particular_environment_ref	
	
func set_world_environment(enum_tipo_nivel : TIPO_NIVEL):
	match enum_tipo_nivel:
		TIPO_NIVEL.PERFIL:
			world_environment.environment = perfil_environment	
		TIPO_NIVEL.PARTICULAR:	
			world_environment.environment = particular_environment 	
			
		
	
#endregion


