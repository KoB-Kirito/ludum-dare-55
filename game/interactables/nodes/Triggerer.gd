class_name Triggerer
extends Triggerable
## Triggers all children when triggered


## Ignore every second trigger
@export var ping_pong: bool = false
var triggered: bool


func trigger() -> void:
	if ping_pong:
		if triggered:
			triggered = false
			return
		triggered = true
	
	for c in get_children():
		if c.has_method("trigger"):
			c.trigger()
