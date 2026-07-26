extends Node

# Each puzzle now also carries the character presenting it and the
# hint/instructions shown next to their portrait while the puzzle is active.
var puzzle_list : Dictionary = { 
	"puzzle1" : {
		"scene" : "res://scenes/puzzles/camion/puzzle_camion.tscn",
		"character" : "Annabelle",
		"hint" : "Load every instrument and box into the truck. Drag each object inside and make sure it stays put.",
	},
	"puzzle2" : {
		"scene" : "res://scenes/puzzles/lights/puzzle_lights.tscn",
		"character" : "Fred",
		"hint" : "Match each spotlight's color to its target. Toggle the lights and rotate the trusses until every target lights up.",
	},
	"puzzle3" : {
		"scene" : "res://scenes/puzzles/tower/puzzle_tower.tscn",
		"character" : "Sarah",
		"hint" : "Stack and place each piece to build the tower, then make sure the sun sits stable above the line.",
	},
}

var controls_scene = load("res://scenes/puzzle_controls.tscn")
var hint_scene = load("res://scenes/puzzle_hint.tscn")

var deleting_puzzle := false

var current_puzzle_scene
var current_puzzle_controls
var current_puzzle_hint
var current_puzzle_idx

func load_puzzle(puzzle_idx):
	deleting_puzzle = false
	current_puzzle_idx = puzzle_idx
	_spawn_puzzle_scene()

	current_puzzle_controls = controls_scene.instantiate()
	add_child(current_puzzle_controls)
	current_puzzle_controls.retry_pressed.connect(retry_puzzle)
	current_puzzle_controls.skip_pressed.connect(skip_puzzle)

	_spawn_puzzle_hint()

func kill_puzzle():
	if current_puzzle_scene != null:
		current_puzzle_scene.queue_free()
		current_puzzle_scene = null
	if current_puzzle_controls != null:
		current_puzzle_controls.queue_free()
		current_puzzle_controls = null
	if current_puzzle_hint != null:
		current_puzzle_hint.queue_free()
		current_puzzle_hint = null

func retry_puzzle():
	if current_puzzle_scene != null:
		current_puzzle_scene.queue_free()
	_spawn_puzzle_scene()

func skip_puzzle():
	on_puzzle_completed()

func _spawn_puzzle_scene():
	var puzzle_res = load(puzzle_list[current_puzzle_idx]["scene"])
	current_puzzle_scene = puzzle_res.instantiate()
	add_child(current_puzzle_scene)
	# Keep the puzzle scene below the controls/hint so retrying doesn't draw
	# the new puzzle instance on top of the Retry/Skip buttons or the hint box.
	move_child(current_puzzle_scene, 0)
	current_puzzle_scene.connect("puzzle_completed",on_puzzle_completed)

func _spawn_puzzle_hint():
	var puzzle_data = puzzle_list[current_puzzle_idx]
	var character = get_parent().chara_res_dict.get(puzzle_data["character"])
	current_puzzle_hint = hint_scene.instantiate()
	add_child(current_puzzle_hint)
	current_puzzle_hint.set_character(character)
	current_puzzle_hint.set_hint(puzzle_data["hint"])

# Lets the active puzzle script update its hint as the puzzle state changes,
# e.g. from within a puzzle scene: get_parent().update_hint("Almost there!")
func update_hint(text: String):
	if current_puzzle_hint != null:
		current_puzzle_hint.set_hint(text)

func on_puzzle_completed():
	if !deleting_puzzle:
		get_parent().next_transition("puzzle_out")
		deleting_puzzle = true
