extends Node

var puzzle_list : Dictionary = { 
	"puzzle1" : "res://scenes/puzzles/puzzle_camion.tscn",
	"puzzle2" : "res://scenes/puzzle_placeholder.tscn"
	
}

var current_puzzle_scene 

func load_puzzle(puzzle_idx):
	var puzzle_res = load(puzzle_list[puzzle_idx])
	current_puzzle_scene = puzzle_res.instantiate()
	add_child(current_puzzle_scene)
	current_puzzle_scene.connect("puzzle_completed",on_puzzle_completed)

func kill_puzzle():
	get_child(0).queue_free()

func on_puzzle_completed():
	get_parent().next_transition("puzzle_out")
