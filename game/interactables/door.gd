@tool
class_name Door
extends Triggerable


## Open and close in editor
@export var open: bool:
	set(value):
		if Engine.is_editor_hint():
			trigger()
	get:
		return is_open

@export_subgroup("Settings")
## Duration for closing/opening
@export var duration: float = 3.0
## Opening in which direction
@export_enum("Left", "Right") var direction: int = 0

@export_category("DoorScene")
## Part that should move
@export var door_node: Node3D

var is_open: bool = false
var original_rotation: Vector3

func _ready() -> void:
	if is_open:
		if direction == 0: # left
			original_rotation = rotation_degrees + Vector3(0, 90, 0)
		else: # right
			original_rotation = rotation_degrees - Vector3(0, 90, 0)
	else:
		original_rotation = rotation_degrees


func trigger() -> void:
	%snd_squeak.play()
	
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	if is_open:
		# close door
		is_open = false
		tween.tween_property(door_node, "rotation_degrees", original_rotation, duration)
		
		
	else:
		# open door
		is_open = true
		if direction == 0: # left
			tween.tween_property(door_node, "rotation_degrees", original_rotation + Vector3(0, 90, 0), duration)
		else:
			tween.tween_property(door_node, "rotation_degrees", original_rotation - Vector3(0, 90, 0), duration)
