extends Node
class_name State
signal on_state_change
var character_instance : CharacterBody2D

func set_character_instance(character_to_set : CharacterBody2D):
	character_instance = character_to_set

func Enter() -> void:
	pass

func Exit() -> void:
	pass	
	
func Update(_delta:float):
	pass	

func Physics_Update(delta: float) -> void:	
	pass
