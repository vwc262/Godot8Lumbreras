extends Node

@export var foldState : bool
@export var verticalBackground : Node
@export var horizontalBackground : Node
@export var buttons : Array[Button]

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func ToggleUI():
	if foldState:
		foldState = false
	else:
		foldState = true

	verticalBackground.visible = foldState
	horizontalBackground.visible = foldState
	for but in buttons:
		but.visible = foldState
		
