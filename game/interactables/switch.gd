extends Interactable


## Will start in that position
@export_enum("Up", "Down") var state: int = 0
## Can't be triggered again
@export var only_once: bool = false
## Will trigger all targets at once
@export var targets: Array[Triggerable]

var triggered: bool


func _ready() -> void:
	if state:
		%AnimationPlayer.play("down")


func interact() -> void:
	if only_once:
		if triggered:
			return
		triggered = true
	
	%snd_press.play()
	if state:
		%AnimationPlayer.play("up")
		state = 0
	else:
		%AnimationPlayer.play("down")
		state = 1
	
	for target: Triggerable in targets:
		if is_instance_valid(target):
			target.trigger()
