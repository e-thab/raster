extends Control

signal reposition(pos)
signal color_changed(color)
signal picker_opened
signal drag_end

@export var color: Color

var dragging = false
var selecting_color = false
var offset = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite.self_modulate = color


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if dragging:
		var mouse_pos = get_viewport().get_mouse_position()
		var new_pos = mouse_pos + offset
		
		new_pos = new_pos.clamp(Vector2.ZERO, Vector2(get_viewport().size) - Vector2.ONE)
		
		if position != new_pos:
			position = new_pos
			reposition.emit(position)
	
	if selecting_color:
		var offset = Vector2.ZERO
		if position.x < 300:
			offset.x = 5
		else:
			offset.x = -298 - 5  # Picker width = 298
		
		if position.y < 300:
			offset.y = 5
		else:
			offset.y = -408 - 5
		
		$ColorPicker.position = position + offset


func hide_picker():
	$ColorPicker.hide()


func _on_sprite_gui_input(event):
	if Input.is_action_just_pressed("Click"):
		offset = position - get_viewport().get_mouse_position()
		dragging = true
		$ColorPicker.hide()
		set("mouse_default_cursor_shape", Control.CURSOR_DRAG)
	elif Input.is_action_just_released("Click"):
		dragging = false
		set("mouse_default_cursor_shape", Control.CURSOR_POINTING_HAND)
		drag_end.emit()
	if Input.is_action_just_pressed("RightClick"):
		if selecting_color:
			$ColorPicker.hide()
			selecting_color = false
		else:
			$ColorPicker.show()
			selecting_color = true
			picker_opened.emit()


func _on_color_picker_color_changed(color):
	$Sprite.self_modulate = color
	color_changed.emit(color)
