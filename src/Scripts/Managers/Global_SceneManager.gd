extends Node


#region Variables
var scenes = {}
var idScenePerfil = 100
var idSceneGraficador = 200
var world_environment : WorldEnvironment
var perfil_environment: Environment
var particular_environment: Environment
#La cantidad de ventanas que va a tener el viewport para scroll
var total_windows : int = 3

var scroll_reference : ScrollContainer = null
var viewport_size_x = 0

enum TIPO_NIVEL {GRAFICADOR,PERFIL,PARTICULAR,}

var viewports_references = {}
#endregion


#region Funciones
#Almacena las referencias de los particulares
func add_scene(idSceneKey:int,scene:Node):
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
	viewport_size_x = viewportsizeX * total_windows
	scroll_reference.get_h_scroll_bar().max_value = viewport_size_x

func get_scroll_step() -> float:	
	return viewport_size_x / total_windows	

func scroll_scene(tipo_nivel:TIPO_NIVEL,idKeySceneToLoad):
	var nivel_existente = scenes.has(idKeySceneToLoad)
	if nivel_existente:
		var step = get_scroll_step()
		var scroll_amount : float = step * tipo_nivel
		var tweenScroll = TweenManager.init_tween(on_scroll_finished.bind(tipo_nivel,true,idKeySceneToLoad))
		tweenScroll.tween_property(scroll_reference, "scroll_horizontal", scroll_amount, .35)
	else:
		UIManager.popUpWindow.showPopUp("En construcción")		
	
	
func set_initial_window():
	scroll_scene(TIPO_NIVEL.PERFIL,idScenePerfil)	
	
func on_scroll_finished(tipo_nivel,makeVisible,idKeySceneToLoad):
	for viewportWindow  in viewports_references.values():
		viewportWindow.visible = false
	load_scene(idKeySceneToLoad)
	set_viewport_visibility(tipo_nivel,makeVisible)
	
	
	
			

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

func add_subviewport_reference(keyScene:int,viewport:Control):
	viewports_references[keyScene] = viewport 		

func set_viewport_visibility(sceneKey,makeVisible):
	if viewports_references.has(sceneKey):
		viewports_references[sceneKey].visible = makeVisible
	
			
			
		
	
#endregion


