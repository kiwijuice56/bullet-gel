# Base virtual class for all bullets.
class_name Bullet
extends Area2D

func _ready() -> void:
	$VisibleOnScreenNotifier2D.screen_exited.connect(_on_screen_exited)

# Automatically delete when off screen. Configure $VisibleOnScreenNotifier2D's shape
# for accurate culling, although its better to have a larger shape so that particle
# effects don't abruptly dissapear
func _on_screen_exited() -> void:
	queue_free()
