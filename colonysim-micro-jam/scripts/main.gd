extends Node2D

var building = false

var food = 0
var metal = 0
var people = 0

func construct():
	$buildCD.start()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$CanvasLayer/Panel/money.text = str(int(food))
	$CanvasLayer/Panel/metal.text = str(int(metal))
	$CanvasLayer/Panel/people.text = str(int(people))


func _on_build_cd_timeout() -> void:
	building = false
