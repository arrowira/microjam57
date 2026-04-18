extends Node2D



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position = Vector2(-get_global_mouse_position().x,get_global_mouse_position().y)
