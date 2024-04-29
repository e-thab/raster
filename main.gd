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

var col_a: Color = Color.RED
var col_b: Color = Color.GREEN
var col_c: Color = Color.BLUE


# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().get_root().size_changed.connect(_on_window_resize)
	
	pos_a = get_pixel($HandleA.position)
	pos_b = get_pixel($HandleB.position)
	pos_c = get_pixel($HandleC.position)
	
	var grid = $GridContainer
	grid.columns = grid_size
	pixel_size = 600 / grid_size
	
	for y in range(grid_size):
		var column = []
		column.resize(grid_size)
		column.fill(0)
		img.append(column)
	
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
	
	draw_triangle()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func get_pixel(pos):
	# Get image 'Pixel' coordinates from actual screen pixel coordinates
	return Vector2i(pos.x/pixel_size, pos.y/pixel_size)


func clear():
	for i in img:
		for pixel in i:
			pixel.fill(pixel_color)


func draw_triangle():
	clear()
	
	midpoint_line(pos_a.x, pos_a.y, pos_b.x, pos_b.y, Color.WHITE)
	midpoint_line(pos_b.x, pos_b.y, pos_c.x, pos_c.y, Color.WHITE)
	midpoint_line(pos_c.x, pos_c.y, pos_a.x, pos_a.y, Color.WHITE)
	
	scanline_interpolate([pos_a, pos_b, pos_c])


func midpoint_line(x0, y0, x1, y1, color):
	if x1 < x0:
		# Swap (x0, x1) + (y0, y1)
		var t = x0
		x0 = x1
		x1 = t
		t = y0
		y0 = y1
		y1 = t
	
	var f = func(x, y):
		return y*(x1-x0) - x*(y1-y0) - x1*y0 + x0*y1
	
	var slope = float(y1 - y0) / float(x1 - x0)
	
	if 0 <= slope and slope < 1:
		var y = y0
		for x in range(x0, x1+1):
			img[x][y].fill(color)
			if f.call(x+1, y+0.5) < 0:
				y += 1
	elif -1 <= slope and slope < 0:
		var y = y0
		for x in range(x0, x1+1):
			img[x][y].fill(color)
			if f.call(x+1, y-0.5) > 0:
				y -= 1
	elif slope <= -1:
		var x = x1
		for y in range(y1, y0+1):
			img[x][y].fill(color)
			if f.call(x-0.5, y+1) > 0:
				x -= 1
	elif slope >= 1:
		var x = x0
		for y in range(y0, y1+1):
			img[x][y].fill(color)
			if f.call(x+0.5, y+1) > 0:
				x += 1


func scanline_interpolate(pts):
	var area = func(A, B, C):
		return abs(( A.x*(B.y - C.y) + B.x*(C.y - A.y) + C.x*(A.y - B.y) ) / 2)
	
	var T = area.call(pts[0], pts[1], pts[2])
	
	for y in range(0, grid_size):
		var found = false
		var x_start = -1
		var x_end = -1
		for x in range(0, grid_size):
			if img[x][y].fill_color != pixel_color:
				if not found:
					found = true
					x_start = x
				x_end = x
		
		if x_start > -1 and x_end > -1:
			for x in range(x_start, x_end + 1):
				var p = Vector2(x, y)
				var a = area.call(p, pts[1], pts[2]) / T
				var b = area.call(p, pts[2], pts[0]) / T
				var c = area.call(p, pts[0], pts[1]) / T
				
				img[x][y].fill(Color(
					a * col_a.r + b * col_b.r + c * col_c.r,
					a * col_a.g + b * col_b.g + c * col_c.g,
					a * col_a.b + b * col_b.b + c * col_c.b,
					a * col_a.a + b * col_b.a + c * col_c.a,
				))


func _on_window_resize():
	pixel_size = get_viewport().size.x / grid_size
	print(get_viewport().size)


func _on_handle_a_reposition(pos):
	var pixel_pos = get_pixel(pos)
	if pos_a != pixel_pos:
		pos_a = pixel_pos
		draw_triangle()


func _on_handle_b_reposition(pos):
	var pixel_pos = get_pixel(pos)
	if pos_b != pixel_pos:
		pos_b = pixel_pos
		draw_triangle()


func _on_handle_c_reposition(pos):
	var pixel_pos = get_pixel(pos)
	if pos_c != pixel_pos:
		pos_c = pixel_pos
		draw_triangle()


func _on_handle_a_color_changed(color):
	if col_a != color:
		col_a = color
		draw_triangle()


func _on_handle_b_color_changed(color):
	if col_b != color:
		col_b = color
		draw_triangle()


func _on_handle_c_color_changed(color):
	if col_c != color:
		col_c = color
		draw_triangle()


func _on_handle_a_picker_opened():
	$HandleB.hide_picker()
	$HandleC.hide_picker()


func _on_handle_b_picker_opened():
	$HandleA.hide_picker()
	$HandleC.hide_picker()


func _on_handle_c_picker_opened():
	$HandleA.hide_picker()
	$HandleB.hide_picker()
