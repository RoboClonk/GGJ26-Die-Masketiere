extends Node2D

@onready var player: Player = $Player
@onready var enemies: Node2D = $Enemies
@onready var enemy_spawn_points: Node2D = $EnemySpawnPoints
@onready var enemy_spawn_timer: Timer = $EnemySpawnTimer

@export var level_id: Globals.LevelId
@export var enemy_scenes: Array[PackedScene]
@export var enemy_waves: Array[Node2D]


func _ready() -> void:
	# Inform all enemies where the player is.
	for enemy in enemies.get_children():
		if "target" in enemy:
			enemy.target = player
			
	Globals.mask_collected.connect(_on_mask_collected)
	
	# Remove the wave nodes as they are only spawned later.
	for wave in enemy_waves:
		if wave:
			enemies.remove_child(wave)


func _on_enemy_spawn_timer_timeout() -> void:
	var enemy_scene = enemy_scenes.pick_random()
	if not enemy_scene:
		push_error("There are no enemy scenes defined for this level!")
		return
	var enemy = enemy_scene.instantiate()
	var spawn_point = enemy_spawn_points.get_children().pick_random()
	if not spawn_point:
		push_error("There are no enemy spawn points defined in this level!")
		return
	
	# TODO Only spawn if there is no enemy near this spawn point.
	# TODO Only spawn if the player is not at this spawn point.
		
	enemy.position = spawn_point.position
	enemies.add_child(enemy)


func _on_mask_collected(mask_id: int) -> void:
	print("Mask "+ str(mask_id) + " collected.")
	Globals.mask_count[level_id] += 1
	Globals.recalculate_mask_effects.emit()

	# Spawn a wave of enemies.
	if mask_id < enemy_waves.size():
		var wave = enemy_waves[mask_id]
		if wave:
			for enemy in wave.get_children():
				wave.remove_child(enemy)
				enemies.add_child(enemy)
	
	# Start regularly spawning enemies.
	enemy_spawn_timer.start()
