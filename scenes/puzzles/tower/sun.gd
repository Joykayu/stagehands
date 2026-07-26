extends "res://scripts/draggable_body.gd"

var is_stable : bool = false
var stable_threshold := 5.0

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	if rigid_body_2d.linear_velocity.length() < stable_threshold:
		is_stable = true
		print("STABLE")
	else:
		is_stable = false
