extends Node2D

var inMouse = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_clickbox_mouse_entered() -> void:
	inMouse = true


func _on_clickbox_mouse_exited() -> void:
	inMouse = false
