# Shoots bullets at the player.
class_name ShootyBlob
extends Enemy

@export var bullet_scene: PackedScene
@export var shoot_cooldown_max: float = 1.5
@export var shoot_cooldown_min: float = 0.5

var target: PlayerBlob

func _ready() -> void:
	super._ready()
	scale = Vector2(0.2, 0.2) * (randf() + 0.5)
	$ShootDelayTimer.timeout.connect(_on_shoot_timeout)
	$PlayerDetectionArea.area_entered.connect(_on_player_detected)

func _on_player_detected(player_area: Area2D) -> void:
	target = player_area
	if $ShootDelayTimer.is_stopped():
		$ShootDelayTimer.start(get_shoot_delay_time())

func _on_shoot_timeout() -> void:
	if not is_instance_valid(target):
		return
	
	var new_bullet: Bullet = bullet_scene.instantiate()
	
	new_bullet.direction = (target.global_position - global_position).normalized()
	
	get_tree().get_root().add_child(new_bullet)
	
	# Moving it to the top of the node tree will prevent the bullet from clipping
	# over the enemy sprite.
	get_tree().get_root().move_child(new_bullet, 0)
	
	# Set layer "enemy_bullet" to true
	new_bullet.set_collision_layer_value(4, true)
	
	# We also have to make sure the bullet starts at the enemy's position.
	new_bullet.global_position = global_position
	
	$ShootDelayTimer.start(get_shoot_delay_time())

func get_shoot_delay_time() -> float:
	return shoot_cooldown_min + (shoot_cooldown_max - shoot_cooldown_min) * (64 - GlobalState.difficulty) / 64.0

func death() -> void:
	# Again, stop from shooting.
	$ShootDelayTimer.stop()
	$ShootDelayTimer.start(999)
	
	# Hide some ugly sprites.
	$BlackSprite.visible = false
	$WhiteSprite.visible = false
	super.death()
