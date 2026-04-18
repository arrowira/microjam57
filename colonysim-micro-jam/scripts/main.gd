extends Node2D

var building = false

func construct():
	$buildCD.start()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_build_cd_timeout() -> void:
	building = false
