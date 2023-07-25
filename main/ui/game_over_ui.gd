class_name GameOverUI
extends Control

func _ready() -> void:
	self.modulate.a = 0

func game_over(final_score: int) -> void:
	$Label.text = "your final score was\n%d\ntry again" % final_score
	
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(get_node("../HUD"), "modulate:a", 0.0, 0.5)
	tween.tween_property(self, "modulate:a", 1.0, 0.5)
	await tween.finished
	
	$DelayTimer.start()
	await $DelayTimer.timeout
	
	tween = get_tree().create_tween()
	tween.tween_property(get_node("../HUD"), "modulate:a", 1.0, 0.5)
	tween.tween_property(self, "modulate:a", 0.0, 0.5)
