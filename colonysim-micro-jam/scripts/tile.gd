extends Node2D

var inMouse = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("click") and inMouse:
		$EquilateralTriangle.modulate.a = 0.5


func _on_clickbox_mouse_entered() -> void:
	inMouse = true


func _on_clickbox_mouse_exited() -> void:
	inMouse = false
