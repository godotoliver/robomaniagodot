extends RigidBody2D

@export var speed: float = 60.0
@export var damage: int = 5
@export var health: int = 100
@export var explosion: PackedScene
@onready var ui_manager = get_tree().get_current_scene().get_node("UIManager")

var player_node = null;


func _on_hit(damage_amount: int) -> void:
	health -= damage_amount
	if(name == "Crusher1"):
		ui_manager.update_crusher_1_health(health)
	if(name == "Crusher2"):
		ui_manager.update_crusher_2_health(health)
	if health <= 0:
		queue_free()

func _on_body_entered(body: Node) -> void:
	var temp = body.get_groups()
	if body.is_in_group("bullet"):
		var bullet_node = body.get_parent()
		var contact_point = bullet_node.global_position
		var bullet_damage = bullet_node.damage
		bullet_node.queue_free()
		_on_hit(bullet_damage)

		if explosion:
			var tempExplosion = explosion.instantiate()
			tempExplosion.global_position = contact_point
			get_tree().current_scene.add_child(tempExplosion)
			tempExplosion.emitting = true

	if body.is_in_group("player"):
		player_node = body

func _on_body_exited(body:Node) -> void:
	if body.is_in_group("player"):
		player_node = null

func _damage_player(delta: float) -> void:
	if (player_node == null):
		return;
	
	var contact_point = player_node.global_position
	player_node.take_damage(damage * delta * 3)
	if explosion:
		var tempExplosion = explosion.instantiate()
		tempExplosion.global_position = contact_point
		get_tree().current_scene.add_child(tempExplosion)
		tempExplosion.emitting = true

func _process(delta: float) -> void:
	_damage_player(delta)
