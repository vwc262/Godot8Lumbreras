extends Popup

@onready var label = $Label

# Called when the node enters the scene tree for the first time.
func _ready():
	UIManager.set_popUp_window(self)
	pass # Replace with function body.
		
func showPopUp(message):
	label.text = message	
	show()
