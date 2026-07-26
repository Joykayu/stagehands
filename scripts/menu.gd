extends Control

const THETA := 5.0
const FREQ := 1.5

var sprites : Array[Dictionary]

func _ready():
	for child in get_children():
		if child is ColorRect and child.get_child_count() > 0 and child.get_child(0) is Sprite2D:
			var sprite = child.get_child(0)
			sprites.append({
				sprite = sprite,
				time_count = randf_range(0.0, 1.0 / FREQ),
				sign = 1 if randi() % 2 == 0 else -1
			})

func _process(delta):
	var interval = 1.0 / FREQ
	for entry in sprites:
		entry.time_count += delta
		if entry.time_count > interval:
			entry.time_count = 0.0
			entry.sprite.rotation = entry.sign * deg_to_rad(randf_range(0.0, THETA))
			entry.sign *= -1
