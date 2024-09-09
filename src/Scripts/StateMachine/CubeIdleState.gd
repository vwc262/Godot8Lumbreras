extends State
class_name CubeIdleState
func Enter():
	print("idle State")
	stop_movement()	
	
func stop_movement():
	character_instance.velocity = Vector2(0,0)	
		
func Physics_Update(delta:float):
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		on_state_change.emit("movestate")
	
		

	
	
