extends Popup

@onready var label = $Panel/Label
@onready var panel = $Panel

# Called when the node enters the scene tree for the first time.
func _ready():
	UIManager.set_popUp_window(self)
		
func showPopUp(message):
	show()
	var tween = TweenManager.init_tween(_on_finish_tween)
	TweenManager.tween_animacion(tween, panel, "modulate:a", 1.0, 0.5)
	label.text = message	

func hide_popup():
	hide()
	panel.modulate = Color(1,1,1,0)

func _on_finish_tween():
	pass


func _on_visibility_changed():
	if !visible:
		hide_popup()
