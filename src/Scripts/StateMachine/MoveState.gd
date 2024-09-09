extends State
class_name MoveState

const SPEED  = 300

func Enter():
	print("move state")
	
func Exit():
	#character_instance.velocity = Vector2(0,0)
	pass
	
func Physics_Update(delta:float):
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		character_instance.velocity.x = direction * SPEED
	else:
		on_state_change.emit("cubeidlestate")
