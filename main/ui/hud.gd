class_name HUD
extends Control

# Wait until cutscene is complete to show HUD elements.
func _ready() -> void:
	modulate.a = 0
	await get_node("../Title").tutorial_complete
	
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 0.5)
