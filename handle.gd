extends Control

signal reposition(pos)
signal drag_end

@export var color: Color

var dragging = false
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


func _on_sprite_gui_input(event):
	if Input.is_action_just_pressed("Click"):
		offset = position - get_viewport().get_mouse_position()
		dragging = true
	elif Input.is_action_just_released("Click"):
		dragging = false
		drag_end.emit()
