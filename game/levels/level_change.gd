extends Area3D


@export_file("*.tscn") var next_level: String
@export_enum("Slide", "Fade") var animation: int
@export var duration: float = 2.0
@export_color_no_alpha var color: Color


func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		body.paused = true 
		SceneTransition.change_scene(next_level, animation, duration, color)
