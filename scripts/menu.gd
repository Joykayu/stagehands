extends Control

const THETA := 5.0
const FREQ := 1.5

func _ready():
	for child in get_children():
		if child is ColorRect and child.get_child_count() > 0 and child.get_child(0) is Sprite2D:
			var sprite = child.get_child(0)
			sprite.set_meta(&"time_count", randf_range(0.0, 1.0 / FREQ))
			sprite.set_meta(&"sign", 1 if randi() % 2 == 0 else -1)

func _process(delta):
	var interval = 1.0 / FREQ
	for child in get_children():
		if child is ColorRect and child.get_child_count() > 0 and child.get_child(0) is Sprite2D:
			var sprite = child.get_child(0)
			var t = sprite.get_meta(&"time_count", 0.0) + delta
			if t > interval:
				t = 0.0
				var s = sprite.get_meta(&"sign", 1)
				sprite.rotation = s * deg_to_rad(randf_range(0.0, THETA))
				sprite.set_meta(&"sign", -s)
			sprite.set_meta(&"time_count", t)
