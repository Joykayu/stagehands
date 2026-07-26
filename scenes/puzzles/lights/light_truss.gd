@tool

extends Node2D

var rotation_step := 10
var translation_step := 0.1

var lights_on := true

var a = 1
var colors = [Color(1,0,0,a), Color(0,1,0,a), Color(0,0,1,a)]
var channels = ["R", "G", "B"]
@export var color_idx := 0

@export var initial_rotation := 0 :
	set(value):
		initial_rotation = value
		if is_node_ready():
			%Spotlight.rotation = deg_to_rad(value)

func _ready():
	%Spotlight.rotation = deg_to_rad(initial_rotation)
	%LightSource.color = colors[color_idx]
	
	
func _on_on_off_button_toggled(toggled_on):
	%LightSource.visible = toggled_on
	lights_on = toggled_on

func _on_color_button_pressed():
	color_idx += 1
	color_idx %= 3
	%LightSource.color = colors[color_idx]


func _on_move_down_button_button_down():
	%PathFollow2D.progress_ratio += translation_step


func _on_move_up_button_button_down():
	%PathFollow2D.progress_ratio -= translation_step


func _on_rotate_right_button_button_down():
	%Spotlight.rotate(deg_to_rad(rotation_step))


func _on_rotate_left_button_button_down():
	%Spotlight.rotate(deg_to_rad(-rotation_step))
