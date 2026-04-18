extends Node2D

var tile = preload("res://scenes/tile.tscn")

var gridSize = 40

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# right arrows
	for row in range(gridSize):
		for col in range(gridSize):
			var newTile = tile.instantiate()
			newTile.position.x = 170*col
			newTile.position.y = 95*col + 190*row
			add_child(newTile)
	# left arrows
	for row in range(gridSize):
		for col in range(gridSize):
			var newTile = tile.instantiate()
			newTile.position.x = 170*col + 50
			newTile.position.y = 95*col + 190*row + 95
			newTile.rotation = PI
			add_child(newTile)
