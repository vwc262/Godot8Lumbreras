extends Node

func _on_button_pressed():
	NavigationManager.emit_signal('ResetCameraPosition')
