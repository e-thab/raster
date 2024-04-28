extends Control

signal hovering(pixel)

var x = -1
var y = -1
var grid_color: Color
var fill_color: Color

# Called when the node enters the scene tree for the first time.
func _ready():
	$PixelFill.color = fill_color
	$GridBorder.color = grid_color


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func fill(color):
	fill_color = color
	$PixelFill.color = color
