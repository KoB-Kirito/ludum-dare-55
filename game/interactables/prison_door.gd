@tool
extends Triggerable


## Duration for closing/opening
@export var duration: float = 3.0
## Opening in which direction
@export_enum("Left", "Right") var direction: int = 0
## Already open?
@export var open: bool = false:
	set(value):
		if Engine.is_editor_hint():
			if moving:
				return
			trigger()
	get:
		return is_open

var moving: bool = false
var is_open: bool = false
var init_rotation: Vector3 = rotation_degrees


func trigger() -> void:
	if moving:
		return
	moving = true
	
	%snd_squeak.play()
	
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	if open:
		tween.tween_property(%door_angle, "rotation_degrees", init_rotation, duration)
		tween.tween_callback(func(): is_open = false)
		
	else:
		if direction == 0:
			# left
			tween.tween_property(%door_angle, "rotation_degrees", init_rotation + Vector3(0, 90, 0), duration)
		else:
			tween.tween_property(%door_angle, "rotation_degrees", init_rotation - Vector3(0, 90, 0), duration)
		tween.tween_callback(func(): is_open = true)
	
	tween.tween_callback(func(): moving = false)
