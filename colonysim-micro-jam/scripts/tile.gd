extends Node2D

var inMouse = false
var inMirrorMouse = false
var id = 0
var industrialID = 0
var building = false
var flipped = false
var buildCD = false

var leftGround = Color(0.377, 0.457, 0.33, 1.0)
var rightGround = Color(0.454, 0.375, 0.577, 1.0)
var abyss = Color(0.043, 0.043, 0.043, 1.0)
var leftFertile = Color(0.37, 0.542, 0.291, 1.0)
var rightFertile = Color(0.693, 0.485, 0.785, 1.0)
var leftSunny = Color(0.697, 0.624, 0.451, 1.0)
var rightSunny = Color(0.773, 0.58, 0.5, 1.0)


var boost = 0
var baseOutput = 0
var durability = 100

var manager
var defaultMod = 1
@onready var buildMenu = $BuildMenu
var sparkles = preload("res://scenes/sparkles.tscn")

#on ready stuff
func _ready() -> void:
	z_index = position.y/100.0
	manager = get_parent().get_parent()
	if flipped:
		$BuildMenu.rotation=PI
		$sprites.rotation=PI
	id = randi_range(0,20)
	if position.x > 2000:
		$EquilateralTriangle.modulate = rightGround
	else:
		$EquilateralTriangle.modulate = leftGround
	idUpdate()
	remove_child(buildMenu)



func idUpdate():
	if id == 1:
		if position.x > 2000:
			$EquilateralTriangle.modulate = rightFertile
		else:
			$EquilateralTriangle.modulate = leftFertile
	elif id == 2:
		$EquilateralTriangle.modulate = abyss
		defaultMod = 1
	elif id == 3:
		if position.x > 2000:
			$EquilateralTriangle.modulate = rightSunny
		else:
			$EquilateralTriangle.modulate = leftSunny
	get_parent().get_parent().get_node("StatusMenu").configurestatus(industrialID,id,boost,baseOutput)


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
		sprite.modulate = Color(0.244, 0.33, 0.424, 1.0)
		baseOutput = 0.25
		if flipped:
			$sprites/FactoryLeft.visible=true
		else:
			$sprites/FactoryRight.visible=true
		manager.metal-=5
		manager.people-=1
	#farm
	if buildID == 2:
		if id == 1:
			boost=1
			var sparks = sparkles.instantiate()
			get_parent().add_child(sparks)
			sparks.position = position
			sparks.z_index = z_index+1
		if flipped:
			$sprites/FarmHouseLeft.visible=true
		else:
			$sprites/FarmHouseRight.visible=true
		baseOutput = 1
		manager.metal-=2
		manager.people-=2
	#house
	if buildID == 3:
		if flipped:
			$sprites/ResidentialLeft.visible=true
		else:
			$sprites/ResidentialRight.visible=true
		baseOutput = 0.8
		manager.people+=2
		manager.metal-=4
		sprite.modulate.r +=0.05
	if buildID == 4:
		if id == 3:
			boost=1
			var sparks = sparkles.instantiate()
			get_parent().add_child(sparks)
			sparks.position = position
			sparks.z_index = z_index+1
		if flipped:
			$sprites/PowerplantLeft.visible=true
		else:
			$sprites/PowerplantRight.visible=true
		baseOutput = 0.5
		manager.people-=1
		manager.metal-=4
		sprite.modulate = Color(0.244, 0.33, 0.424, 1.0)
		
	building=false
	if !onStart:
		$BuildMenu.visible = false
	get_parent().get_parent().construct()
	

func build():
	add_child(buildMenu)
	$BuildMenu.visible=true
	building = true
	get_parent().get_parent().building = true
	
	
	
#structure longterm effects
var t = 0
func _physics_process(delta: float) -> void:
	if industrialID != 0 and industrialID!=3:
		if randf() < 0.1 and randf() < 0.05 and durability != 0:
			durability-=1
			if randf() < 0.1:
				durability -= 10
		if inMouse:
			get_parent().get_parent().get_node("StatusMenu").updateDurability(durability)

		
	if industrialID!=0:

		if durability == 0:
			$sprites/repairButton.visible = true
			$sprites.modulate = Color.RED
		else:
			t+=1
			if t%50==0:
				match industrialID:
					1:
						if manager.power < 2:
							$sprites.modulate = Color.WHITE*0.3
						else:
							$sprites.modulate = Color.WHITE
							manager.metal+=baseOutput+boost
							manager.power-=baseOutput*1.5
					2:
						if manager.power < 2:
							$sprites.modulate = Color.WHITE*0.3
						else:
							$sprites.modulate = Color.WHITE
							manager.food+=baseOutput+boost
							manager.power-=baseOutput/1.5
					3:
						manager.food-=baseOutput+boost
					4:
						manager.power+=baseOutput+boost
						$sprites.modulate = Color.WHITE
			

func _process(delta: float) -> void:
	#button opacities
	if building:
		if !(manager.req(1,10) and manager.req(2,1)):
			$BuildMenu/Panel/factoryB.modulate.a = 0.2
		else:
			$BuildMenu/Panel/factoryB.modulate.a = 1
		if !(manager.req(1,4) and manager.req(2,4)):
			$BuildMenu/Panel/farmB.modulate.a = 0.2
		else:
			$BuildMenu/Panel/farmB.modulate.a = 1
		if !(manager.req(1,8)):
			$BuildMenu/Panel/houseB.modulate.a = 0.2
		else:
			$BuildMenu/Panel/houseB.modulate.a = 1
		if !(manager.req(1,8) and manager.req(2,1)):
			$BuildMenu/Panel/powerB.modulate.a = 0.2
		else:
			$BuildMenu/Panel/powerB.modulate.a = 1
	
	#highlighting
	if inMouse or inMirrorMouse:
		$EquilateralTriangle.modulate.a = 0.8
	else:
		$EquilateralTriangle.modulate.a = defaultMod
		

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
	get_parent().get_parent().get_node("StatusMenu").position = global_position
	get_parent().get_parent().get_node("StatusMenu").configurestatus(industrialID,id,boost,baseOutput)


func _on_clickbox_mouse_exited() -> void:
	inMouse = false


func _on_timer_timeout() -> void:
	#spread biomes
	for i in range(10):
		for area in $area.get_overlapping_areas():
			if area.name == "clickbox":
				if area.get_parent().id == 2:
					if randf()<0.05:
						id = 2
				if area.get_parent().id == 1:
					if randf()<0.05:
						id = 1
				
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
	if manager.req(1,4) and manager.req(2,4):
		construction(2,0)



func _on_house_b_button_down() -> void:
	if manager.req(1,8):
		construction(3,0)


func _on_X_down() -> void:
	$BuildMenu.visible=false
	building = false
	get_parent().get_parent().construct()
	


func _on_power_b_button_down() -> void:
	if manager.req(1,8) and manager.req(2,1):
		construction(4,0)


func repair() -> void:
	if manager.req(1,5):
		$sprites/repairButton.visible=false
		manager.metal-=5
		durability = 100
