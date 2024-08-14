extends TextureRect
@export var speed_rotation = 3.0

func _ready() -> void:
	pivot_offset = size * .5
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotation += speed_rotation * delta
