class_name Player
extends CharacterBody2D

#Allows ninjas to change the movement parameters
@export var speed: float = 300.0
@export var jump_velocity: float = -1000.0
@export var gravity_force: Vector2 = Vector2(0, 3000.0)
@export var projectile : PackedScene
@onready var animator: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
@export var projectile_speed : float = 750
@export var health: float = 100
@export var shoot_time : float = 0.5
var can_shoot : bool = true
@onready var ui_manager = get_tree().get_current_scene().get_node("UIManager")

#Runs every physics frame
func _physics_process(delta: float) -> void:
	#If we are in the air, apply gravity
	if not is_on_floor():
		velocity += gravity_force * delta

	if Input.is_action_pressed("fire"):
		shoot()

	#If jump button pressed and we are on the ground
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	#The inputs along the X-Axis return a float from -1.0 to 1.0
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		#Move in the current direction multiplied by the movement speed
		velocity.x = direction * speed
	else:
		#Otherwise move the velocity to 0
		velocity.x = move_toward(velocity.x, 0, speed)

	# Animation logic — separated from movement logic
	if abs(velocity.x) > 0.1:
		animator.play("run")
	else:
		animator.play("idle")

	# Make sprite face the right direction while moving
	if velocity.x > 0:
		sprite.flip_h = false  # Face right
	elif velocity.x < 0:
		sprite.flip_h = true
	else:
		if get_global_mouse_position().x > position.x:
			sprite.flip_h = false
		elif get_global_mouse_position().x < position.x:  # Face left
			sprite.flip_h = true

	#Moves the CharacterBody based on the velocity
	move_and_slide()

func shoot():
	if !can_shoot:
		return
	else:
		can_shoot = false
		var projectile_instance = projectile.instantiate()
		projectile_instance.global_position = global_position

		var direction = (get_global_mouse_position() - global_position).normalized()
		var projectile_velocity = direction * projectile_speed

		# Call a method on the projectile to set velocity
		projectile_instance.set_velocity(projectile_velocity)

		get_tree().current_scene.add_child(projectile_instance)
		await get_tree().create_timer(shoot_time).timeout
		can_shoot = true

func take_damage(damage_amount: float) -> void:
	health -= damage_amount
	ui_manager.update_player_health(health)
	if health <= 0:
		ui_manager.enable_lose_ui()
		queue_free()
