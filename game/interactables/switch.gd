@tool
extends Interactable


## Open and close in editor
@export var press: bool:
	set(value):
		if Engine.is_editor_hint():
			interact()
	get:
		return false

@export_subgroup("Settings")
## Can't be triggered again. If timer is set can only be triggered when timer is not running.
@export var only_once: bool = false:
	set(value):
		only_once = value
		if not only_once:
			triggered = false
			reset_timer = -1

## Time until it triggers again in seconds. -1 = Will stay
@export_range(-1, 30, 1) var reset_timer: float = -1:
	set(value):
		reset_timer = value
		if value > 0:
			only_once = true

@export_group("Targets")
## Will trigger all targets at once
@export var targets: Array[Triggerable]

var is_pressed: bool
var triggered: bool
var reset: bool


func _ready() -> void:
	triggered = false


func interact() -> void:
	if only_once:
		if triggered:
			return
		triggered = true
	
	if reset:
		reset = false
		triggered = false
	else:
		if reset_timer > 0:
			%Timer.start(reset_timer)
			%snd_timer.play()
			triggered = true
	
	%snd_press.play()
	
	if is_pressed:
		%AnimationPlayer.play("up")
		is_pressed = false
	else:
		%AnimationPlayer.play("down")
		is_pressed = true
	
	for target: Triggerable in targets:
		if is_instance_valid(target):
			target.trigger()


func _on_timer_timeout() -> void:
	%snd_timer.stop()
	triggered = false
	reset = true
	interact()
