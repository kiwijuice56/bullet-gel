# The blobs that the player controls.
class_name PlayerBlob
extends Character

# Used to spawn blob copies when hurt.
const PLAYER_SCENE_PATH: String = "res://main/character/player_blob/player_blob.tscn"

const HEALTH_STAGES: Array[PackedScene] = [
	preload("res://main/character/player_blob/health_blob_positions/health_blobs_4.tscn"),
	preload("res://main/character/player_blob/health_blob_positions/health_blobs_2.tscn"),
	preload("res://main/character/player_blob/health_blob_positions/health_blobs_1.tscn"),
]

# The scene for what bullet is spawned when the player shoots. This scene should
# inherit from the Bullet class.
@export var bullet_scene: PackedScene

@export var movement_speed: float = 70.0

# The minimum time between shots.
@export var shoot_cooldown: float = 0.2

# How much time a blob can go between being hurt.
@export var invincibility_time: float = 1.2

# How far two child blobs will spawn away from eachother.
@export var spawn_distance: float = 25.0

func _ready() -> void:
	# Call Character's ready to initialize collision signals.
	super._ready()
	
	$HealthBlobRoot.add_child(HEALTH_STAGES[3 - health].instantiate())
	# We do the inverse operation of scaling on the player to keep the size of the
	# blobs constant.
	if health < 3:
		$HealthBlobRoot.scale *= Vector2(5.0 / 3.0, 5.0 / 3.0) * (3 - health)
	
	$InvincibilityTimer.start(invincibility_time)

func _physics_process(delta: float) -> void:
	# Move the player based on directional input.
	var direction: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	position += direction * movement_speed * delta
	
	# Keep player position within the screen.
	position = position.clamp(Vector2(0, 0), get_viewport_rect().size)
	
	# Spawn a bullet when shoot is pressed and cooldown is off.
	if Input.is_action_pressed("shoot") and $ShootDelayTimer.is_stopped():
		# We need to wait a frame before calling this method, as we can't remove
		# nodes in the middle of a physics signal
		shoot()

func _on_area_entered(area: Area2D) -> void:
	if (area is Bullet or area is Enemy) and $InvincibilityTimer.is_stopped():
		call_deferred("split")

func shoot() -> void:
	var new_bullet: Bullet = bullet_scene.instantiate()
	
	# Adding the bullet as a child to the root node instead of the player prevents
	# the bullet from moving with the player.
	get_tree().get_root().add_child(new_bullet)
	
	# Moving it to the top of the node tree will prevent the bullet from clipping
	# over the player sprite.
	get_tree().get_root().move_child(new_bullet, 0)
	
	# Set layer "player_bullet" to true.
	new_bullet.set_collision_layer_value(2, true)
	
	# We also have to make sure the bullet starts at the player's position.
	new_bullet.global_position = global_position
	
	new_bullet.direction = Vector2.UP
	
	# Start the cooldown to prevent another shot until shoot_cooldown seconds have passed.
	$ShootDelayTimer.start(shoot_cooldown)
	
	# Play the shooting animation.
	$AnimationPlayer.play("shoot")

func split() -> void:
	$CollisionShape2D.disabled = true
	
	# Prevent this player from shooting with an impossible delay (until it is removed
	# from the scene tree at the end of this function).
	$ShootDelayTimer.stop()
	$ShootDelayTimer.start(999)
	
	if health - 1 > 0:
		GlobalState.player_blob_count += 2
		var spawn_direction: Vector2 = Vector2(1, 0).rotated(2 * PI * randf())
		for idx in range(2):
			var new_player: PlayerBlob = load(PLAYER_SCENE_PATH).instantiate()
			
			new_player.health = health - 1
			
			get_tree().get_root().add_child(new_player)
			new_player.global_position = global_position
			
			# Scale down the new players by 66%.
			new_player.scale = scale * Vector2(3.0 / 5.0, 3.0 / 5.0)
			
			# Both blobs should go in opposite directions.
			if idx == 1:
				spawn_direction *= -1
			
			# Move the new players into their positions using a tween.
			var tween: Tween = get_tree().create_tween()
			tween = tween.set_ease(Tween.EASE_OUT)
			tween = tween.set_trans(Tween.TRANS_QUAD)
			
			tween.tween_property(new_player, "position", 
			new_player.position + spawn_distance / 2 * spawn_direction, 0.1)
	
	GlobalState.player_blob_count -= 1
	$DeathSoundPlayer.pitch_scale = 0.4 + randf() * 0.4 - 0.2
	
	$AnimationPlayer.stop()
	$AnimationPlayer.play("death")
	await $AnimationPlayer.animation_finished
	queue_free()
