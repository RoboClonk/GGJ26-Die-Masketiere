extends EnemyBase

@export var trumpet : AudioStreamPlayer2D
@export var stomp : AudioStreamPlayer2D

@export var charge_damage : int
@export var stomp_damage : int
@export var stomp_radius : float = 200.0


func start_attack() -> bool:
	var attack_number = randi_range(0, 1)
	if attack_number == 0:
		charge_attack(charge_damage, trumpet, 60.0, 80.0, 5.0)
	elif attack_number == 1:
		stomp_attack(stomp_damage)
	elif attack_number == 2:
		default_attack(damage)
		
	return true


func stomp_attack(in_damage : int):
	debug_log("Started stomp attack")
	current_attack_name = "Stomp attack"
	if(!move_to(get_position_in_arc_before_target(45.0, 35.0))):
		interrupt_attack()
		return
	
	debug_log("Stomp attack waiting for target reached")
	await target_reached
	debug_log("Stomp attack target reached")
	
	if(!get_target()):
		interrupt_attack()
		return
	
	enemy_spritesheet.play("Attack")
	can_move = false
	trumpet.play()
	
	var timer_duration = 1.0
	var timer = create_local_timer(timer_duration)
	if !timer:
		interrupt_attack()
		return
	attack_sprite.scale = Vector2.ONE * (stomp_radius/128)
	while(timer and timer.time_left > 0.1):
		# Attack sprite to hint where the enemy is attacking.
		var progress = 1.0 - timer.time_left / timer_duration
		attack_sprite.modulate.a = progress * 0.5
		# We need to cancel the loop if we are not inside the tree, else we have an infinite loop.
		if is_inside_tree(): 
			await get_tree().process_frame
		else:
			return
	
	if !timer: # When timer was freed early that means our attack was interrupted.
		attack_sprite.modulate.a = 0.0
		enemy_spritesheet.play("Walk")
		return
	
	if !_is_attacking:
		attack_sprite.modulate.a = 0.0
		return
	attack_sprite.modulate.a = 0.0
	# Do not need to check for target since we are applying AOE
	
	var overlap_check = OverlapCheck.create_physics_overlap(self, global_position, stomp_radius, 6)
	assert(overlap_check)
	overlap_check.on_colliders_collected.connect(Callable(self, "stomp_area_damage"))


func stomp_area_damage(intersections : Array[Dictionary]):
	debug_log("Stomp area damage: Intersections %s" % [intersections])
	for intersection in intersections:
		var collider = intersection["collider"]
		if collider:
			debug_log("Stomp area collider %s" % [collider.get_name()])
			if collider.has_method("take_damage") and collider != self:
				if collider is not Player:
					var pushback_direction = (collider.global_position - global_position).normalized() * 50.0
					collider.take_damage(self, stomp_damage, pushback_direction)
				else:
					collider.take_damage(self, stomp_damage)
	
	var timer = create_local_timer(randf_range(0.5, 0.8)) # Additional cooldown
	await timer.timeout
	finish_attack()
	enemy_spritesheet.play("Walk")


func interrupt_attack():
	enemy_spritesheet.play("Walk")
	super.interrupt_attack()
