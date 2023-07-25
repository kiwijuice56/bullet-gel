class_name DangerousBlob
extends Enemy

func _ready() -> void:
	super._ready()
	scale = Vector2(0.2, 0.2) * (randf() + 0.5)
