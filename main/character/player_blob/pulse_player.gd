# Creates a pulsing sound as the player shoots.
class_name ShootStreamPlayer
extends AudioStreamPlayer

func _process(delta: float) -> void:
	if Input.is_action_pressed("shoot"):
		volume_db += 32.0 * delta
	else:
		volume_db -= 32.0 * delta
	volume_db = clamp(volume_db, -32, 0)
 
