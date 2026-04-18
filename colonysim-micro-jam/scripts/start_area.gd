extends Area2D




func _on_timer_timeout() -> void:
	for area in get_overlapping_areas():
		if area.name == "clickbox":
			area.get_parent().consBC(1,0,true)
	queue_free()
