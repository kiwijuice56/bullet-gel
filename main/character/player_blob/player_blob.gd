# The blobs that the player controls.
class_name PlayerBlob
extends Character

# The scene for what bullet is spawned when the player shoots. This scene should
# inherit from the Bullet class.
@export var bullet_scene: PackedScene

@export var movement_speed: float = 70.0

# The minimum time between shots.
@export var shoot_cooldown: float = 0.2

@export var pitch_minimum: float = 0.8
@export var pitch_maximum: float = 1.2

var current_pitch: float = pitch_minimum

func _physics_process(delta: float) -> void:
	# Move the player based on directional input.
	var direction: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	position += direction * movement_speed * delta
	
	# Spawn a bullet when shoot is pressed and cooldown is off.
	if Input.is_action_pressed("shoot") and $ShootDelayTimer.is_stopped():
		shoot()

func _on_area_entered(area: Area2D) -> void:
	if area is Bullet:
		split()

func shoot() -> void:
	var new_bullet: Bullet = bullet_scene.instantiate()
		
	# Adding the bullet as a child to the root node instead of the player prevents
	# the bullet from moving with the player.
	get_tree().get_root().add_child(new_bullet)
	
	# Moving it to the top of the node tree will prevent the bullet from clipping
	# over the player sprite.
	get_tree().get_root().move_child(new_bullet, 0)
	
	# We also have to make sure the bullet starts at the player's position
	new_bullet.global_position = global_position
	
	new_bullet.direction = Vector2.UP
	
	# Start the cooldown to prevent another shot until shoot_cooldown seconds have passed
	$ShootDelayTimer.start(shoot_cooldown)
	
	# Play the shooting animation
	$AnimationPlayer.play("shoot")
	
	# Constantly change the pitch upward, slightly randomly but within a cycle
	current_pitch += randf() / 4.0
	if current_pitch > pitch_maximum:
		current_pitch = pitch_minimum
	$ShootSoundPlayer.pitch_scale = current_pitch
	$ShootSoundPlayer.play()

func split() -> void:
	pass
