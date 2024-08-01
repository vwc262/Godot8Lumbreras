extends Popup

@onready var label = $Panel/Label
@onready var panel = $Panel
@onready var popup_container = $".."

# Called when the node enters the scene tree for the first time.
func _ready():
	UIManager.set_popUp_window(self)
		
func showPopUp(message):
	show()
	popup_container.visible = true
	var tween = TweenManager.init_tween(_on_finish_tween)
	TweenManager.tween_animacion(tween, panel, "modulate:a", 1.0, 0.5)
	label.text = message	

func hide_popup():
	hide()
	popup_container.visible = false
	panel.modulate = Color(1,1,1,0)

func _on_finish_tween():
	pass


func _on_visibility_changed():
	if !visible:
		hide_popup()
