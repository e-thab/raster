extends Control

@export var pixel: PackedScene
@export var grid_size = 60
var img  # Array of Pixels that represent the image


# Called when the node enters the scene tree for the first time.
func _ready():
	var grid = $GridContainer
	grid.columns = grid_size
	var pixel_size = 600 / grid_size
	
	for y in range(grid_size):
		for x in range(grid_size):
			var p = pixel.instantiate()
			p.set_size( Vector2(pixel_size, pixel_size),  )
			grid.add_child(p)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
