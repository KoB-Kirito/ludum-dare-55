extends Area3D


@export_file("*.tscn") var next_level: String


func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		body.paused = true
		SceneTransition.change_scene(next_level)
