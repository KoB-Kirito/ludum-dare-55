class_name Triggerer
extends Triggerable
## Triggers all children when triggered


func trigger() -> void:
	for c in get_children():
		if c.has_method("trigger"):
			c.trigger()
