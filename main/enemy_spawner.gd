# Spawn enemies on the top of the screen, slowly ramping up difficulty.
class_name EnemySpawner
extends Node

# List of enemies to randomly spawn.
@export var enemy_list: Array[PackedScene]

# The initial range of the cooldown for spawning enemies.
@export var spawn_time_min: float = 1.0
@export var spawn_time_max: float = 3.0

# How much the spawn time is scaled for each difficulty (see GlobalState.difficulty)
@export var difficulty_speed_up: float = 0.93

func _ready() -> void:
	$SpawnTimeout.timeout.connect(_on_spawn_timeout)
	
	await get_node("../UILayer/Title").tutorial_complete
	
	start_spawning()

func _on_spawn_timeout() -> void:
	$SpawnTimeout.start(get_spawn_time())
	
	var new_enemy: Enemy = enemy_list.pick_random().instantiate()
	get_tree().get_root().add_child(new_enemy)
	new_enemy.position = Vector2(randf() * 256, -32)

func get_spawn_time() -> float:
	var difficulty_mult: float = pow(difficulty_speed_up, GlobalState.difficulty)
	return spawn_time_min + randf() * (spawn_time_max - spawn_time_min) * difficulty_mult

func stop_spawning() -> void:
	$SpawnTimeout.stop()

func start_spawning() -> void:
	$SpawnTimeout.start(get_spawn_time())

func remove_all_enemies() -> void:
	for child in get_children():
		if child is Enemy:
			child.queue_free()
