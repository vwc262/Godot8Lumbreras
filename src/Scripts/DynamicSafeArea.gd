extends MarginContainer

# Se llama cuando el nodo está listo
func _ready():
	pass

# Se llama cuando el nodo recibe una notificación
func _notification(what):
	# Verifica si la notificación es una redimensión de la pantalla
	if what == NOTIFICATION_RESIZED:
		_handle_screen_resize()

# Maneja la redimensión de la pantalla para ajustar los márgenes
func _handle_screen_resize():
	var os_name = OS.get_name()
	
	# Verifica si la plataforma es Android o iOS
	if os_name == "Android" || os_name == "iOS":
		var screen_size = get_viewport_rect().size
		var safe_area = DisplayServer.get_display_safe_area()
		var safe_area_top = safe_area.position.y
		var safe_area_sides = safe_area.position.x
		
		# Calcula el área segura para la parte inferior de la pantalla
		var safe_area_bottom = screen_size.y - (safe_area.position.y + safe_area.size.y)
		
		# Ajusta el área segura para iOS teniendo en cuenta la escala de la pantalla
		if os_name == "iOS":
			var screen_scale = DisplayServer.screen_get_scale()
			safe_area_top /= screen_scale
			safe_area_sides /= screen_scale
			safe_area_bottom /= screen_scale
		
		# Ajusta los márgenes dependiendo de la orientación de la pantalla
		if screen_size.x > screen_size.y:  # Pantalla en modo horizontal
			var margin = 40 
			add_theme_constant_override("margin_top", margin)
			add_theme_constant_override("margin_right", safe_area_sides + margin)
			add_theme_constant_override("margin_bottom", safe_area_bottom + margin)
			add_theme_constant_override("margin_left", safe_area_sides + margin)
		else:  # Pantalla en modo vertical
			var margin = 0
			add_theme_constant_override("margin_top", safe_area_top + margin)
			add_theme_constant_override("margin_right", margin / 2)
			add_theme_constant_override("margin_bottom", safe_area_bottom + margin)
			add_theme_constant_override("margin_left", margin)
