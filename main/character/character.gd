# Base virtual class for all characters, including the player and all enemies. Implements
# basic collision detection.
class_name Character
extends Area2D

func _ready() -> void:
	area_entered.connect(_on_area_entered)

# Called when another area collides with this character. Usage varies, but make sure
# that this node's collision mask/layers are set properly! Only areas whose `collision_layer`
# matches with this node's `collision_mask` are processed here. 
func _on_area_entered(area: Area2D) -> void:
	if area is Bullet:
		pass # example
