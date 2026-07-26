extends Control

var current_dragged_body : Node2D
var objects_in_camion : Dictionary [String, bool]

signal puzzle_completed

func _ready():
	for body in $Draggables.get_children():
		body.connect("body_dragged",on_body_dragged)
		objects_in_camion[body.name] = false

func _on_boundaries_mouse_entered():
	if current_dragged_body != null :
		current_dragged_body.disconnect_mouse()
		current_dragged_body = null

func on_body_dragged(body):
	current_dragged_body = body


func _on_camion_body_entered(body):
	var body_name = body.get_parent().name
	if objects_in_camion.has(body_name):
		objects_in_camion[body_name] = true
	if objects_in_camion.values().all(is_true):
		puzzle_completed.emit()

func _on_camion_body_exited(body):
	var body_name = body.get_parent().name
	if objects_in_camion.has(body_name):
		objects_in_camion[body_name] = false

func is_true(value:bool):
	return value
	
