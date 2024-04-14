extends Area3D


## Next level to load
@export_file("*.tscn") var next_level: String
## Transition animation
@export_enum("Slide", "Fade") var animation: int
## Transition duration
@export var duration: float = 2.0
## Transition color
@export_color_no_alpha var color: Color


func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		body.paused = true 
		SceneTransition.change_scene(next_level, animation, duration, color)
