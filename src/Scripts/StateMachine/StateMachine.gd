extends Node
class_name  StateMachine

@export var character_instance : CharacterBody2D
var states = {}
@export var current_state : State
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	for child : State in get_children():
		states[child.name.to_lower()] = child
		child.set_character_instance(character_instance)
		child.on_state_change.connect(change_state)
		#vincular cambio de estado mediante signal
	if current_state:
		current_state.Enter()	


func _process(delta: float) -> void:
	if current_state:
		current_state.Update(delta)
		
func _physics_process(delta: float) -> void:
	if current_state:
		current_state.Physics_Update(delta)		


func change_state(stateToChange:String):	
		current_state.Exit()
		current_state = states.get(stateToChange.to_lower())
		current_state.Enter()				
