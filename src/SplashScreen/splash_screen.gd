extends Control
class_name SplashScreen

@export var _time: float = 1.5
@export var _fade_time: float = 1

signal finished

func start() -> void:
	modulate.a = 0
	show()
	var tween: Tween = create_tween()
	tween.connect("finished", _finish)
	tween.tween_property(self, "modulate:a", 1, _fade_time)
	tween.tween_interval(_time)
	tween.tween_property(self, "modulate:a", 0, _time)
	
func _finish() -> void:
	emit_signal("finished")
	queue_free()
