class_name Door
extends Triggerable


## Open and close in editor
@export var open: bool = false

@export_subgroup("Settings")
## Duration for closing/opening
@export var duration: float = 3.0
## Opening in which direction
@export_enum("Left", "Right") var direction: int = 0

@export_category("DoorScene")
## Part that should move
@export var door_node: Node3D

var original_rotation: Vector3

func _ready() -> void:
	#TODO: Find why door has wrong angle sometimes when level loads..
	#if Engine.is_editor_hint():
	#	return
	
	original_rotation = rotation_degrees
	set_state(open)

func trigger() -> void:
	%snd_squeak.play()
	set_state(!open)

func set_state(set_open: bool) -> void:
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	if !set_open:
		# close door
		open = false
		#BUG: Tween uses wrong direction sometimes, needs better rotate function
		tween.tween_property(door_node, "rotation_degrees", original_rotation, duration)
	else:
		# open door
		open = true
		if direction == 0: # left
			tween.tween_property(door_node, "rotation_degrees", original_rotation + Vector3(0, 90, 0), duration)
		else:
			tween.tween_property(door_node, "rotation_degrees", original_rotation - Vector3(0, 90, 0), duration)
