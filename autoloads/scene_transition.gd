extends CanvasLayer

const LEFT = -4930
const MIDDLE = -508.0
const RIGHT = 1930.0

const FADE_DURATION = 1.0

enum ANIMATION {SLIDE, FADE}


func _ready() -> void:
	%Fade.position.x = RIGHT


func change_scene(scene_path: String, animation: ANIMATION, color: Color) -> void:
	var tween = create_tween()
	
	match animation:
		ANIMATION.SLIDE:
		%Fade.position.x = RIGHT
		
		tween.tween_property(%Fade, "position:x", MIDDLE, FADE_DURATION)
		tween.tween_callback(func(): get_tree().change_scene_to_file(scene_path))
		tween.tween_property(%Fade, "position:x", LEFT, FADE_DURATION)
