extends Node2D

var inMouse = false
var id = 0
var building = false
var flipped = false
var buildCD = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$StatusMenu.position=Vector2(-1,-1)
	if flipped:
		$BuildMenu.rotation=PI
		$StatusMenu.rotation=PI
	id = randi_range(0,20)
	if position.x > 2000:
		$EquilateralTriangle.modulate = Color.DARK_BLUE
	else:
		$EquilateralTriangle.modulate = Color.DARK_OLIVE_GREEN
	idUpdate()

func configurestatus():
	if id == 2:
		#void
		$StatusMenu/Panel/statusText.text = "Void tile; unbuildable"

func idUpdate():
	if id == 1:
		$EquilateralTriangle.modulate.r = 0.2
	elif id == 2:
		$EquilateralTriangle.modulate = Color.WHITE * 0.1
		$EquilateralTriangle.modulate.a = 1
	configurestatus()

func construction(id, sprite):
	
	if sprite == 0:
		sprite = $EquilateralTriangle
	#factory
	if id == 0:
		for area in get_parent().get_parent().get_node("mousemirror").get_node("mouse").get_overlapping_areas():
			if area.name == "clickbox":
				area.get_parent().get_node("EquilateralTriangle").modulate = Color.GRAY
		sprite.modulate = Color.GRAY
	
	building=false
	$BuildMenu.visible = false
	get_parent().get_parent().construct()
	
func build():
	$BuildMenu.visible=true
	building = true
	get_parent().get_parent().building = true
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if get_parent().get_parent().building:
		$StatusMenu.visible=false
	if Input.is_action_just_pressed("click") and inMouse:
		if !get_parent().get_parent().building:
			var mirrorId
			for area in get_parent().get_parent().get_node("mousemirror").get_node("mouse").get_overlapping_areas():
				if area.name == "clickbox":
					mirrorId = area.get_parent().id
			#check for not void space
			if id!=2 and mirrorId!=2:
				build()

func _on_clickbox_mouse_entered() -> void:
	inMouse = true
	$StatusMenu.visible = true


func _on_clickbox_mouse_exited() -> void:
	inMouse = false
	$StatusMenu.visible = false


func _on_timer_timeout() -> void:
	#spread biomes
	for i in range(10):
		for area in $area.get_overlapping_areas():
			if area.name == "clickbox":
				
				if area.get_parent().id == 1:
					if randf()<0.05:
						id = 1
				if area.get_parent().id == 2:
					if randf()<0.05:
						id = 2
				idUpdate()


func _on_factory_b_button_down() -> void:
	construction(0,0)
