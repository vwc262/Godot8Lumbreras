extends Node


#region Variables
var particular_scenes = {}
var perfil_scene : Node3D = null
#endregion


#region Funciones
#Almacena la referencia del perfil
func set_perfil_scene(perfilScene:Node3D):
	perfil_scene = perfilScene
	pass

#Almacena las referencias de los particulares
func add_particular_scene(idEstacionKey:int,particularScene:Node3D):
	particular_scenes[idEstacionKey] = particularScene
	pass
	
#endregion


