extends CanvasLayer

const LEFT = -3850
const MIDDLE = -960
const RIGHT = 1930.0

enum {SLIDE, FADE}


func _ready() -> void:
	%Fade.position.x = RIGHT


func change_scene(scene_path: String, animation: int, duration: float, color: Color) -> void:
	# set gradient color
	%Fade.texture.gradient.set_color(1, Color(color, 1.0))
	%Fade.texture.gradient.set_color(2, Color(color, 1.0))
	
	var tween = create_tween()
	
	match animation:
		SLIDE:
			%Fade.modulate = Color.WHITE
			%Fade.position.x = RIGHT
			
			tween.tween_property(%Fade, "position:x", MIDDLE, duration / 2)
			tween.tween_callback(func(): get_tree().change_scene_to_file(scene_path))
			tween.tween_property(%Fade, "position:x", LEFT, duration / 2)
		
		FADE:
			%Fade.modulate = Color.TRANSPARENT
			%Fade.position.x = MIDDLE
			
			tween.tween_property(%Fade, "modulate", Color.WHITE, duration / 2)
			tween.tween_callback(func(): get_tree().change_scene_to_file(scene_path))
			tween.tween_property(%Fade, "modulate", Color.TRANSPARENT, duration / 2)
