extends Node


#region Variables
var scenes = {}
var idScenePerfil = 100
var world_environment : WorldEnvironment
var perfil_environment: Environment
var particular_environment: Environment

enum TIPO_NIVEL {PERFIL,PARTICULAR}
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
		UIManager.popUpWindow.showPopUp("Sitio en construcción")
	return nivel_encontrado		
		

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


