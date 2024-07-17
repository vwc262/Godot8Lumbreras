extends Node

func _on_button_pressed():
	ManejadorClicks.emit_signal('ResetCameraPosition')
