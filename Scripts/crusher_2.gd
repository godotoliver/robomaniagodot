extends "res://Scripts/crusher_parent.gd"
func _ready() -> void:
	apply_central_impulse(Vector2.RIGHT * speed)
