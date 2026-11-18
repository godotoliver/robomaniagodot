extends Node2D

var velocity: Vector2 = Vector2.ZERO
@export var damage: int = 1

func set_velocity(new_velocity: Vector2) -> void:
	velocity = new_velocity
	rotation = velocity.angle()  # 🔄 Rotate bullet to face the direction of travel

func _physics_process(delta: float) -> void:
	position += velocity * delta

	# Optional: destroy bullet if it goes off screen
	#if not get_viewport_rect().has_point(global_position):
		#queue_free()
