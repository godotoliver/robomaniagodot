extends "res://Scripts/crusher_parent.gd"

var direction: Vector2 = Vector2.LEFT

func _physics_process(delta: float) -> void:
	if position.x < -550:
		direction = Vector2.RIGHT
	
	if position.x > 550:
		direction = Vector2.LEFT
	
	position = position + direction * speed * delta
