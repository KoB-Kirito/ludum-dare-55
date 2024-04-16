extends CanvasLayer


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://game/levels/Credits.tscn")


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://game/levels/Intro.tscn")
