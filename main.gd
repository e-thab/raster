extends Control

@export var pixel: PackedScene
@export var grid_size = 60
@export var pixel_color: Color
@export var grid_color: Color

var pixel_size = 15
var img: Array  # 2D Array of Pixels that represent the 'image'

# Handle positions converted to Pixel array index pairs, [img[x][y]]
var pos_a: Vector2i = Vector2i.ZERO
var pos_b: Vector2i = Vector2i.ZERO
var pos_c: Vector2i = Vector2i.ZERO


# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().get_root().size_changed.connect(_on_window_resize)
	
	var grid = $GridContainer
	grid.columns = grid_size
	pixel_size = 600 / grid_size
	
	for y in range(grid_size):
		var column = []
		column.resize(grid_size)
		column.fill(0)
		img.append(column)
		print(img[y])
	
	for y in range(grid_size):
		for x in range(grid_size):
			var p = pixel.instantiate()
			p.x = x
			p.y = y
			p.fill_color = pixel_color
			p.grid_color = grid_color
			p.set_size( Vector2(pixel_size, pixel_size) )
			img[x][y] = p
			grid.add_child(p)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func get_pixel(pos):
	# Get image 'Pixel' coordinates from actual screen pixel coordinates
	return Vector2i(pos.x/pixel_size, pos.y/pixel_size)


func _on_window_resize():
	pixel_size = get_viewport().size.x / grid_size
	print(get_viewport().size)


func _on_handle_a_reposition(pos):
	var pixel_pos = get_pixel(pos)
	if pos_a != pixel_pos:
		pos_a = pixel_pos
		print("A: (%s, %s)" % [pos_a.x, pos_a.y])
		# Set handle A here


func _on_handle_b_reposition(pos):
	var pixel_pos = get_pixel(pos)
	if pos_b != pixel_pos:
		pos_b = pixel_pos
		print("B: (%s, %s)" % [pos_b.x, pos_b.y])
		# Set handle B here


func _on_handle_c_reposition(pos):
	var pixel_pos = get_pixel(pos)
	if pos_c != pixel_pos:
		pos_c = pixel_pos
		print("C: (%s, %s)" % [pos_c.x, pos_c.y])
		# Set handle C here
