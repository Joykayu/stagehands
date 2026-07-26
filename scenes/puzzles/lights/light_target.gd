@tool
extends Node2D

var target_complete := false


var channels := {
	"R": false,
	"G": false,
	"B": false
}

@export var target_color := "Red":
	set(value):
		target_color = value
		if is_node_ready():
			%TargetLabel.text = value
			
const target_dict :={
	"Red":
		{
		"R": true,
		"G": false,
		"B": false
		},
	"Green":
		{
		"R": false,
		"G": true,
		"B": false
		},
	"Blue":
		{
		"R": false,
		"G": false,
		"B": true
		},
	"Yellow":
		{
		"R": true,
		"G": true,
		"B": false
		},
	"Magenta":
		{
		"R": true,
		"G": false,
		"B": true
		},
	"Cyan":
		{
		"R": false,
		"G": true,
		"B": true
		},
	"White":
		{
		"R": true,
		"G": true,
		"B": true
		},
	}



func _ready():
	%TargetLabel.text = target_color

func _process(_delta):
	channels = {
	"R": false,
	"G": false,
	"B": false
	}
	for lights in %TargetArea.get_overlapping_areas():
		var truss = lights.get_parent().get_parent().get_parent().get_parent()
		if truss.lights_on:
			channels[truss.channels[truss.color_idx]] = true
	
	if channels == target_dict[target_color]:
		target_complete = true
	else :
		target_complete = false
		
	%LightsOnVFX.visible = target_complete
