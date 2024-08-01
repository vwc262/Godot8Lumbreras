extends Node


#region Variables
var scenes = {}
var idScenePerfil = 100
#endregion


#region Funciones
#Almacena la referencia del perfil
#Almacena las referencias de los particulares
func add_scene(idSceneKey:int,scene:Node3D):
	scenes[idSceneKey] = scene
	pass
	
func unload_scenes():
	for scene in scenes.values():
		scene.visible = false
	pass

func load_scene(idSceneKey:int):
	scenes[idSceneKey].visible = true	
		
	
#endregion


