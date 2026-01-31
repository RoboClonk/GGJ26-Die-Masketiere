extends CharacterBody2D

@export var speed: float = 50
@export var health: float = 3:
	set(value):
		health = value
		if health < 0:
			die()

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var enemy_placeholder: Sprite2D = $EnemyPlaceholder
@onready var sprite_flash: SpriteFlash = $EnemyPlaceholder

var target: Player
var is_player_detected: bool = false

func _physics_process(_delta: float) -> void:
	if is_player_detected:
		var next_target = navigation_agent.get_next_path_position()
		var direction_to_player = (next_target - position).normalized()
		var velocity_to_next_target = direction_to_player * speed
		if navigation_agent.avoidance_enabled:
			# Set the velocity on the navigation agent and then get the safe velocity after avoidance in _on_navigation_agent_2d_velocity_computed.
			navigation_agent.set_velocity(velocity_to_next_target)
		else:
			velocity = velocity_to_next_target
		enemy_placeholder.flip_h = velocity.x < 0
		move_and_slide()


func _on_detection_area_body_entered(_body: Node2D) -> void:
	is_player_detected = true


func _on_detection_area_body_exited(_body: Node2D) -> void:
	is_player_detected = false


func _on_pathfinding_timer_timeout() -> void:
	navigation_agent.target_position = target.position


func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity
	

func take_damage(damage: float) -> void:
	health -= damage
	sprite_flash.flash(0.1, 0.2)


func die() -> void:
	queue_free()
