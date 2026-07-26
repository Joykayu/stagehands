extends Node

var puzzle_list : Dictionary = { 
	"puzzle1" : "res://scenes/puzzles/lights/puzzle_lights.tscn",
	"puzzle2" : "res://scenes/puzzle_placeholder.tscn",
	"puzzle3" : "res://scenes/puzzle_placeholder.tscn",
}

var controls_scene = load("res://scenes/puzzle_controls.tscn")

var deleting_puzzle := false

var current_puzzle_scene
var current_puzzle_controls
var current_puzzle_idx

func load_puzzle(puzzle_idx):
	deleting_puzzle = false
	current_puzzle_idx = puzzle_idx
	_spawn_puzzle_scene()

	current_puzzle_controls = controls_scene.instantiate()
	add_child(current_puzzle_controls)
	current_puzzle_controls.retry_pressed.connect(retry_puzzle)
	current_puzzle_controls.skip_pressed.connect(skip_puzzle)

func kill_puzzle():
	if current_puzzle_scene != null:
		current_puzzle_scene.queue_free()
		current_puzzle_scene = null
	if current_puzzle_controls != null:
		current_puzzle_controls.queue_free()
		current_puzzle_controls = null

func retry_puzzle():
	if current_puzzle_scene != null:
		current_puzzle_scene.queue_free()
	_spawn_puzzle_scene()

func skip_puzzle():
	on_puzzle_completed()

func _spawn_puzzle_scene():
	var puzzle_res = load(puzzle_list[current_puzzle_idx])
	current_puzzle_scene = puzzle_res.instantiate()
	add_child(current_puzzle_scene)
	# Keep the puzzle scene below the controls so retrying doesn't draw
	# the new puzzle instance on top of the Retry/Skip buttons.
	move_child(current_puzzle_scene, 0)
	current_puzzle_scene.connect("puzzle_completed",on_puzzle_completed)

func on_puzzle_completed():
	if !deleting_puzzle:
		get_parent().next_transition("puzzle_out")
		deleting_puzzle = true
