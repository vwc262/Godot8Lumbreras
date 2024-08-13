extends Node
@onready var trect: TextureButton = $"."

var texture_setted = false

func screenshoot() -> void:
	if texture_setted:
		trect.texture_normal = null	
		
		texture_setted = false
	else:
		await RenderingServer.frame_post_draw
	
		var viewport = get_viewport()
		var img = viewport.get_texture()

		trect.texture_normal = img
		
		texture_setted = true


func _on_button_down() -> void:
	screenshoot()
