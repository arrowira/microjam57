extends Node2D

var inMouse = false
var inMirrorMouse = false
var id = 0
var industrialID = 0
var building = false
var flipped = false
var buildCD = false

var manager
var defaultMod = 1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	manager = get_parent().get_parent()
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
		defaultMod = 1
	configurestatus()

func construction(id, sprite):
	consBC(id,sprite,false)
func consBC(id, sprite, onStart):
	industrialID = id
	if sprite == 0:
		sprite = $EquilateralTriangle
	#mirror
	if !onStart:
			for area in get_parent().get_parent().get_node("mousemirror").get_node("mouse").get_overlapping_areas():
				if area.name == "clickbox":
					area.get_parent().consBC(id,0,true)
	#factory
	if id == 1:
		sprite.modulate = Color.GRAY
		manager.metal-=5
	#farm
	if id == 2:
		manager.metal-=2
		sprite.modulate = Color.ANTIQUE_WHITE
	#house
	if id == 3:
		manager.people+=2
		manager.metal-=2
		sprite.modulate = Color.CHOCOLATE
	
	building=false
	$BuildMenu.visible = false
	get_parent().get_parent().construct()
	
func build():
	$BuildMenu.visible=true
	building = true
	get_parent().get_parent().building = true
	
	
	
func _physics_process(delta: float) -> void:
	if industrialID!=0:
		match industrialID:
			1:
				manager.metal+=0.001
			2:
				manager.food+=0.01
				
			
			
			
			
func _process(delta: float) -> void:
	if inMouse or inMirrorMouse:
		$EquilateralTriangle.modulate.a = 0.8
	else:
		$EquilateralTriangle.modulate.a = defaultMod
		
	if get_parent().get_parent().building:
		$StatusMenu.visible=false
	if Input.is_action_just_pressed("click") and inMouse:
		if !get_parent().get_parent().building:
			var mirrorId
			for area in get_parent().get_parent().get_node("mousemirror").get_node("mouse").get_overlapping_areas():
				if area.name == "clickbox":
					mirrorId = area.get_parent().id
			#check for not void space
			if id!=2 and mirrorId!=2 and industrialID == 0:
				#check for adjacent tiles
				var byBuilt = false
				for area in $area.get_overlapping_areas():
					if area.name == "clickbox":
						if area.get_parent().industrialID != 0:
							byBuilt = true
							break
				if byBuilt:
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
	construction(1,0)


func _on_clickbox_area_entered(area: Area2D) -> void:
	if area.name == "mouse":
		inMirrorMouse = true


func _on_clickbox_area_exited(area: Area2D) -> void:
	if area.name == "mouse":
		inMirrorMouse = false


func _on_farm_b_button_down() -> void:
	construction(2,0)


func _on_house_b_button_down() -> void:
	construction(3,0)
