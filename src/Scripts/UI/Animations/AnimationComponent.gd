class_name  AnimationComponent extends Node

enum BOY_ANIMATED_PROPERTY
{
	position,
	rotation,
	scale
}

enum BOY_ORIGINAL_PROPERTY
{
	IN,
	OUT
}

@export var vecIn : Vector2
@export var vecOut :Vector2
@export var useOriginalProperty : BOY_ORIGINAL_PROPERTY
@export var time : float
@export var animatedProperty : BOY_ANIMATED_PROPERTY
@export var transition_type : Tween.TransitionType

var animInOut : bool
var target : Control

func _ready():
	target = get_parent()
	var auxVec = Vector2.ZERO
	match animatedProperty:
		BOY_ANIMATED_PROPERTY.position:
			auxVec = target.position
		BOY_ANIMATED_PROPERTY.rotation:
			auxVec = target.rotation
		BOY_ANIMATED_PROPERTY.scale:
			auxVec = target.scale
			
	match useOriginalProperty:
		BOY_ORIGINAL_PROPERTY.IN:
			vecIn = auxVec
		BOY_ORIGINAL_PROPERTY.OUT:
			vecOut = auxVec

func AnimIn():
	animInOut = false
	add_tween(BOY_ANIMATED_PROPERTY.keys()[animatedProperty],vecIn, time)
	
func AnimOut():
	animInOut = true
	target.visible = true
	add_tween(BOY_ANIMATED_PROPERTY.keys()[animatedProperty],vecOut, time)

func add_tween(property : String, value, seconds : float):
	var tween = get_tree().create_tween()
	tween.tween_property(target, property, value, seconds).set_trans(transition_type)
	tween.connect("finished", EndTween)

func AuxFunc():
	print("Hola Boy")


func _on_button_anim_in_1_pressed():
	pass # Replace with function body.

func EndTween():
	target.visible = animInOut
