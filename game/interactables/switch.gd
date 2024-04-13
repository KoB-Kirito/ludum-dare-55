extends Interactable


@export var only_once: bool = true
@export var targets: Array[Triggerable]

var triggered: bool

func interact() -> void:
	if only_once:
		if triggered:
			return
		triggered = true
	
	%snd_press.play()
	
	for target: Triggerable in targets:
		if is_instance_valid(target):
			target.trigger()
