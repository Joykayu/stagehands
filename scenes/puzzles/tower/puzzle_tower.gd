extends Control

var current_dragged_body : Node2D
var last_body : Node2D

var object_idx := 0

var objects_list =[
	"res://scenes/puzzles/tower/box_lines.tscn",
	"res://scenes/puzzles/tower/truss_1.tscn",
	"res://scenes/puzzles/tower/truss_2.tscn",
	"res://scenes/puzzles/tower/makita_line.tscn",
	"res://scenes/puzzles/tower/plank.tscn",
	"res://scenes/puzzles/tower/triangle_1.tscn",
	"res://scenes/puzzles/tower/plank_2.tscn",
	"res://scenes/puzzles/tower/triangle_2.tscn",
	"res://scenes/puzzles/tower/sun.tscn"
]

var sun_in_objective := false
var sun

signal puzzle_completed

func _ready():
	spawn_object()

func _physics_process(_delta):
	if sun_in_objective and sun.is_stable and !sun.is_dragging:
		puzzle_completed.emit()


func _on_boundaries_mouse_entered():
	if current_dragged_body != null :
		current_dragged_body.disconnect_mouse()
		current_dragged_body = null

func on_body_dragged(body):
	current_dragged_body = body

func on_body_dropped(body):
	if body == last_body:
		spawn_object()

func _on_objective_body_entered(body):
	if body.get_parent().name == "Sun":
		sun_in_objective = true

func _on_objective_body_exited(body):
	if body.get_parent().name == "Sun":
		sun_in_objective = false

func spawn_object():
	if object_idx <= 8:
		var scene = load(objects_list[object_idx])
		var instance = scene.instantiate()
		$Draggables.add_child(instance)
		instance.connect("body_dragged",on_body_dragged)
		instance.connect("body_dropped",on_body_dropped)
		last_body = instance
		if instance.name == "Sun":
			sun = instance
		object_idx += 1
	else:
		return

func is_true(value:bool):
	return value
	
