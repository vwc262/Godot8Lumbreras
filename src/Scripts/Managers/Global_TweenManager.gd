extends Node

func init_tween(Callback) -> Tween:
	var tween = create_tween()
	tween.connect("finished", Callback)
	return tween
	
func tween_animacion(tween_ref: Tween, anim_target, anim_property, anim_valor, anim_tiempo):
	tween_ref.tween_property(anim_target, anim_property, anim_valor, anim_tiempo)
