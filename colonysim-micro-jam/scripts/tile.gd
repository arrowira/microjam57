extends Node2D

var inMouse = false
var special = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	special = randi_range(0,5)
	$EquilateralTriangle.modulate = Color.DARK_BLUE
	if special == 1:
		$EquilateralTriangle.modulate.r = 0.2


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("click") and inMouse:
		$EquilateralTriangle.modulate = Color.GRAY


func _on_clickbox_mouse_entered() -> void:
	inMouse = true


func _on_clickbox_mouse_exited() -> void:
	inMouse = false
