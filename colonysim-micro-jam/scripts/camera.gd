extends Camera2D

var flying = false
func _on_area_2d_mouse_exited() -> void:
	flying = true


func _on_area_2d_mouse_entered() -> void:
	flying = false

func _physics_process(delta: float) -> void:
	if flying and !get_parent().building:
		var dir = (get_local_mouse_position()-Vector2.ZERO).normalized()
		position+=10*dir
		
