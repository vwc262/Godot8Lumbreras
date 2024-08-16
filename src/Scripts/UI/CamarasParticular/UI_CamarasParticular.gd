extends Node

@export var foldState : bool
@export var verticalBackground : Node
@export var horizontalBackground : Node
@export var buttons : Array[Button]
@export var indicationSpriteHome : TextureRect
@export var indicationSprites : Array[TextureRect]


func _ready():
	foldState = true
	verticalBackground.visible = false
	horizontalBackground.visible = false
	var i = 0
	for but in buttons:
		but.visible = false
		but.connect("pressed", func(): _buttonPressed(i))
		i += 1

func ToggleUI():
	if foldState:
		foldState = false
	else:
		foldState = true

	indicationSpriteHome.visible =foldState
	verticalBackground.visible = foldState
	horizontalBackground.visible = foldState
	for but in buttons:
		if foldState:
			but.get_node("AnimationComponent").AnimOut()
		else:
			but.get_node("AnimationComponent").AnimIn()
		
func _buttonPressed(index : int):
	print("Button pressed " + str(index))
	for indi in indicationSprites:
		indi.visible = false
		
	indicationSprites[index].visible = true
