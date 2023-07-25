# Base virtual class for all enemies.
class_name Enemy
extends Character

@export var fall_speed: float = 32
@export var kill_score: int = 8

func _ready() -> void:
	super._ready()
	health = initial_health
	
	fall_speed *= pow(1.01, GlobalState.difficulty)

func _physics_process(delta: float) -> void:
	position.y += delta * fall_speed

func _on_area_entered(area: Area2D) -> void:
	if area is Bullet:
		health -= 1
		area.call_deferred("queue_free")
		
		if health == 0:
			call_deferred("death")
		else:
			hurt()

func death() -> void:
	$CollisionShape2D.disabled = true
	GlobalState.score += kill_score
	$DeathSoundPlayer.pitch_scale = 0.2
	$AnimationPlayer.stop()
	$AnimationPlayer.play("death")
	await $AnimationPlayer.animation_finished
	queue_free()

func hurt() -> void:
	$DeathSoundPlayer.pitch_scale = 0.4
	$AnimationPlayer.stop()
	$AnimationPlayer.play("hurt")
	await $AnimationPlayer.animation_finished
