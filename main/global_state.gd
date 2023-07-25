# Singleton with global variables
extends Node

# Variables used to scale difficulty of enemies, such as how fast they spawn or how
# fast they move. Set by EnemySpawner.
var difficulty: int = 1
var max_difficulty: int = 64

var player_blob_count: int = 1:
	set(val):
		# A signal is used to update the game
		player_blob_count = val
		player_count_updated.emit()

# The player's score for a run
var score: int = 0:
	set(val):
		# A signal is used to update the UI
		score = val
		score_updated.emit()

var difficulty_timer: Timer

signal score_updated
signal player_count_updated

# Setup a timer loop to increase difficulty every second
func _ready() -> void:
	difficulty_timer = Timer.new()
	difficulty_timer.one_shot = true
	add_child(difficulty_timer)
	difficulty_timer.timeout.connect(_on_difficulty_timeout)
	difficulty_timer.start()
	
	reset_state()

func _on_difficulty_timeout() -> void:
	difficulty += 1
	difficulty = min(max_difficulty, difficulty)
	difficulty_timer.start(1.0)

func reset_state() -> void:
	self.score = 0
	self.difficulty = 1
	self.player_blob_count = 1
