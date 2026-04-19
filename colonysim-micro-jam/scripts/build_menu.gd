extends Control

@onready var effects := $Panel/Panel/effects
@onready var buildcosts := $Panel/Panel/buildcosts
func clearLists():
	$Panel/Panel/buildcosts.clear()
	$Panel/Panel/effects.clear()

func factory():
	buildcosts.add_item("-10 metal")
	buildcosts.add_item("-2 people")
	effects.add_item("-0.5 power/sec")
func farm():
	buildcosts.add_item("-4 metal")
	buildcosts.add_item("-4 people")
	effects.add_item("-0.5 power/sec")
func house():
	buildcosts.add_item("-8 metal")
func power():
	buildcosts.add_item("-8 metal")
	buildcosts.add_item("-2 people")



func _on_factory_b_mouse_entered() -> void:
	factory()

func _on_farm_b_mouse_entered() -> void:
	farm()
	
func _on_house_b_mouse_entered() -> void:
	house()
	
func _on_power_b_mouse_entered() -> void:
	power()
