@tool
class_name TriggerableAnimationPlayer
extends AnimationPlayer


## Animation to play when triggered
@export var animation_name: String:
	set(value):
		animation_name = value
		update_configuration_warnings()
	get:
		return animation_name


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	animation_finished.connect(on_animation_finished)


func on_animation_finished(an: String) -> void:
	if an == animation_name:
		Events.cutscene_ended.emit()


func trigger() -> void:
	if not Engine.is_editor_hint():
		Events.cutscene_started.emit()
	play(animation_name)


func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray
	if animation_name.is_empty():
		warnings.append("Animation Name is empty.\n" +
						"Provide the name of the animation that should play when triggered.")
	elif not animation_name in get_animation_list():
		warnings.append(animation_name + " not found in animation list")
	return warnings
