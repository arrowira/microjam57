extends Node2D

var building = false

var food = 10
var metal = 20
var people = 2

func construct():
	$buildCD.start()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func req(id, amt):
	#ids: 0=food, 1=metal, 2=people
	match(id):
		0:
			return amt<food
		1:
			return amt<metal
		2: 
			return amt<people

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$CanvasLayer/Panel/money.text = str(int(food))
	$CanvasLayer/Panel/metal.text = str(int(metal))
	$CanvasLayer/Panel/people.text = str(int(people))


func _on_build_cd_timeout() -> void:
	building = false
