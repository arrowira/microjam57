extends Node2D

var building = false

var food = 40
var metal = 30
var people = 4
var power = 50

func construct():
	$buildCD.start()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func req(id, amt):
	#ids: 0=food, 1=metal, 2=people
	match(id):
		0:
			return amt<=food
		1:
			return amt<=metal
		2: 
			return amt<=people
		3:
			return amt<=power

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if food < 10:
		$CanvasLayer/Panel/lowFood.visible=true
	else:
		$CanvasLayer/Panel/lowFood.visible=false
	
	if power < 2:
		$CanvasLayer/Panel/powerOutage.visible=true
	else:
		$CanvasLayer/Panel/powerOutage.visible=false
	if Input.is_action_just_pressed("exit"):
		Engine.time_scale = 0
		building=true
		$audioManager/music.pitch_scale -= 0.5
		$CanvasLayer/pauseMenu.visible=true
	if building:
		$StatusMenu.visible = false
	$CanvasLayer/Panel/money.text = str(int(food))
	$CanvasLayer/Panel/metal.text = str(int(metal))
	$CanvasLayer/Panel/people.text = str(int(people))
	$CanvasLayer/Panel/power.text = str(int(power))
	
	if food < 0:
		$CanvasLayer/deathPanel.visible=true


func _on_build_cd_timeout() -> void:
	building = false
	$StatusMenu.visible = true


func _on_button_button_down() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")


func _on_resume() -> void:
	Engine.time_scale = 1
	building = false
	$CanvasLayer/pauseMenu.visible=false
	$audioManager/music.pitch_scale += 0.5
