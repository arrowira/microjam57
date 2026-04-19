extends Node2D

var inMouse = false
var inMirrorMouse = false
var id = 0
var industrialID = 0
var building = false
var flipped = false
var buildCD = false

var boost = 0
var baseOutput = 0

var manager
var defaultMod = 1


#on ready stuff
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
	elif id == 1:
		#fertile
		$StatusMenu/Panel/statusText.text = "Fertile land; boosted farm outputs"
	else:
		#normal
		$StatusMenu/Panel/statusText.text = "normal land"
	

func idUpdate():
	if id == 1:
		$EquilateralTriangle.modulate.r = 0.2
	elif id == 2:
		$EquilateralTriangle.modulate = Color.WHITE * 0.1
		$EquilateralTriangle.modulate.a = 1
		defaultMod = 1
	configurestatus()


#create structure
func construction(id, sprite):
	consBC(id,sprite,false)


func consBC(buildID, sprite, onStart):
	
	get_parent().get_parent().get_node("audioManager").place()
	
	industrialID = buildID
	if sprite == 0:
		sprite = $EquilateralTriangle
	#mirror
	if !onStart:
			for area in get_parent().get_parent().get_node("mousemirror").get_node("mouse").get_overlapping_areas():
				if area.name == "clickbox":
					area.get_parent().consBC(buildID,0,true)
	#factory
	if buildID == 1:
		baseOutput = 1
		$sprites/FactoryRight.visible=true
		manager.metal-=5
		manager.people-=1
	#farm
	if buildID == 2:
		if id == 1:
			boost=1
		baseOutput = 2
		manager.metal-=2
		manager.people-=2
		sprite.modulate = Color.ANTIQUE_WHITE
	#house
	if buildID == 3:
		baseOutput = 1
		manager.people+=2
		manager.metal-=5
		sprite.modulate = Color.CHOCOLATE
	
	building=false
	$BuildMenu.visible = false
	get_parent().get_parent().construct()
	
func build():
	$BuildMenu.visible=true
	building = true
	get_parent().get_parent().building = true
	
	
	
#structure longterm effects
var t = 0
func _physics_process(delta: float) -> void:
	if industrialID!=0:
		t+=1
		if t%50==0:
			match industrialID:
				1:
					manager.metal+=baseOutput+boost
				2:
					manager.food+=baseOutput+boost
				3:
					manager.food-=baseOutput+boost
			
			
			
			
func _process(delta: float) -> void:
	#button opacities
	if building:
		if !(manager.req(1,10) and manager.req(2,1)):
			$BuildMenu/Panel/factoryB.modulate.a = 0.2
		else:
			$BuildMenu/Panel/factoryB.modulate.a = 1
		if !(manager.req(1,4) and manager.req(2,2)):
			$BuildMenu/Panel/farmB.modulate.a = 0.2
		else:
			$BuildMenu/Panel/farmB.modulate.a = 1
		if !(manager.req(1,4)):
			$BuildMenu/Panel/houseB.modulate.a = 0.2
		else:
			$BuildMenu/Panel/houseB.modulate.a = 1
	
	#highlighting
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
					get_parent().get_parent().get_node("audioManager").click()
					build()
				else:
					manager.get_node("audioManager").error()
			else:
				manager.get_node("audioManager").error()
			

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
	if manager.req(1,10) and manager.req(2,1):
		construction(1,0)


func _on_clickbox_area_entered(area: Area2D) -> void:
	if area.name == "mouse":
		inMirrorMouse = true


func _on_clickbox_area_exited(area: Area2D) -> void:
	if area.name == "mouse":
		inMirrorMouse = false


func _on_farm_b_button_down() -> void:
	if manager.req(1,4) and manager.req(2,2):
		construction(2,0)



func _on_house_b_button_down() -> void:
	if manager.req(1,4):
		construction(3,0)


func _on_X_down() -> void:
	$BuildMenu.visible=false
	building = false
	get_parent().get_parent().building = false
	
