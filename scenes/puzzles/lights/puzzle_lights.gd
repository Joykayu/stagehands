extends Control

var layout_idx := 0
var curr_layout
var layout_list = [
	"res://scenes/puzzles/lights/layout_1.tscn",
	"res://scenes/puzzles/lights/layout_2.tscn",
	"res://scenes/puzzles/lights/layout_3.tscn"
	]

signal puzzle_completed


func _ready():
	load_layout(layout_list[layout_idx])

func _process(_delta):
	var targets_completed_list = []
	for t in curr_layout.get_children():
		targets_completed_list.append(t.target_complete)
	
	if targets_completed_list.all(is_true):
		get_tree().paused = true
		await get_tree().create_timer(2.0).timeout
		get_tree().paused = false
		next_layout()

func is_true(value:bool):
	return value

func next_layout():
	layout_idx += 1
	if layout_idx == layout_list.size():
		puzzle_completed.emit()
	else:
		load_layout(layout_list[layout_idx])


func load_layout(path):
	if curr_layout != null:
		curr_layout.queue_free()
	var scene = load(path)
	var instance = scene.instantiate()
	add_child(instance)
	curr_layout = instance
