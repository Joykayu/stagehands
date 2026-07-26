extends Node

var puzzle_list : Dictionary = { 
	"puzzle1" : "res://scenes/puzzles/lights/puzzle_lights.tscn",
	"puzzle2" : "res://scenes/puzzle_placeholder.tscn",
	"puzzle3" : "res://scenes/puzzle_placeholder.tscn",
}

var deleting_puzzle := false

var current_puzzle_scene 

func load_puzzle(puzzle_idx):
	deleting_puzzle = false
	var puzzle_res = load(puzzle_list[puzzle_idx])
	current_puzzle_scene = puzzle_res.instantiate()
	add_child(current_puzzle_scene)
	current_puzzle_scene.connect("puzzle_completed",on_puzzle_completed)

func kill_puzzle():
	get_child(0).queue_free()

func on_puzzle_completed():
	if !deleting_puzzle:
		get_parent().next_transition("puzzle_out")
		deleting_puzzle = true
