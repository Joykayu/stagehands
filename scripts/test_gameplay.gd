extends Node

var mouse_in_body := false
var is_dragged := false
var is_rotated := false
var target : Vector2
var omega := 1

func _physics_process(delta):
	if is_rotated and mouse_in_body:
		$Body.rotate(omega*delta)
	if is_dragged and mouse_in_body:
		$Body.apply_force(round((target)/10)*100,get_viewport().get_mouse_position()- $Body.global_position)

func _input(event):
	if event is InputEventMouseMotion and is_dragged:
		target = event.position
	if event is InputEventKey :
		pass

func _on_body_mouse_entered():
	mouse_in_body = true
	print("Mouse IN")

func _on_body_mouse_exited():
	mouse_in_body = false
	is_dragged = false
	is_rotated = false
	print("Mouse OUT")

func _on_body_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton :
		if mouse_in_body and event.button_index == 1:
			is_dragged = event.pressed
			if is_dragged:
				target = event.position
		if event.button_index ==2 :
			is_rotated = event.pressed
	
