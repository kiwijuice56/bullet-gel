# Bullets that travel in a straight line. The direction variable should be set by 
# whatever node spawns this bullet.
class_name BasicBullet
extends Bullet

@export var movement_speed: float = 128.0

var direction: Vector2

func _physics_process(delta: float) -> void:
	position += direction * movement_speed * delta 
