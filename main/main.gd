# Root script.
class_name Main
extends Node

const PLAYER_BLOB_SCENE: PackedScene = preload("res://main/character/player_blob/player_blob.tscn")

func _ready() -> void:
	GlobalState.player_count_updated.connect(_on_player_count_updated)

func _on_player_count_updated() -> void:
	# When the player is completely dead, reset the game.
	if GlobalState.player_blob_count == 0:
		$EnemySpawner.stop_spawning()
		
		# Add a small delay to give the player a buffer 
		$ResetTimer.start()
		await $ResetTimer.timeout
		
		await $UILayer/GameOver.game_over(GlobalState.score)
		
		reset()

func reset() -> void:
	$EnemySpawner.remove_all_enemies()
	GlobalState.reset_state()
	var new_player: PlayerBlob = PLAYER_BLOB_SCENE.instantiate()
	add_child(new_player)
	new_player.global_position = Vector2(128, 128)
	$EnemySpawner.start_spawning()
