extends Node2D

var inMouse = false
var id = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	id = randi_range(0,20)
	if position.x > 2000:
		$EquilateralTriangle.modulate = Color.DARK_BLUE
	else:
		$EquilateralTriangle.modulate = Color.DARK_OLIVE_GREEN
	
	idUpdate()
	

func idUpdate():
	if id == 1:
		$EquilateralTriangle.modulate.r = 0.2
	elif id == 2:
		$EquilateralTriangle.modulate = Color.WHITE * 0.1
		$EquilateralTriangle.modulate.a = 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("click") and inMouse:
		$EquilateralTriangle.modulate = Color.GRAY


func _on_clickbox_mouse_entered() -> void:
	inMouse = true


func _on_clickbox_mouse_exited() -> void:
	inMouse = false


func _on_timer_timeout() -> void:
	for i in range(14):
		for area in $area.get_overlapping_areas():
			if area.name == "clickbox":
				
				if area.get_parent().id == 1:
					if randf()<0.05:
						id = 1
				if area.get_parent().id == 2:
					if randf()<0.05:
						id = 2
				idUpdate()
