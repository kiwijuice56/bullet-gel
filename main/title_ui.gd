class_name TitleUI
extends Control

signal tutorial_complete

func _ready() -> void:
	for idx in range(get_child_count()):
		if not get_child(idx) is Label:
			break
		
		get_child(idx).modulate.a = 0
		get_child(idx).visible = true
		
		var tween: Tween = get_tree().create_tween()
		tween.tween_property(get_child(idx), "modulate:a", 1.0, 0.5)
		
		$DelayTimer.start()
		await $DelayTimer.timeout
		
		tween = get_tree().create_tween()
		tween.tween_property(get_child(idx), "modulate:a", 0.0, 0.5)
	tutorial_complete.emit()
