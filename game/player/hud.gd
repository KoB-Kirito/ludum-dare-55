class_name Hud
extends CanvasLayer


@onready var crosshair: TextureRect = %Crosshair


func _ready() -> void:
	Events.health_updated.connect(on_health_updated)
	Events.transformed_to_ghost.connect(on_transformed_to_ghost)
	Events.returned_to_host.connect(on_returned_to_host)


func _process(_delta: float) -> void:
	if %CountdownTimer.is_stopped():
		return
	
	%CountdownLabel.text = "%20.2f" % %CountdownTimer.time_left


func on_transformed_to_ghost(duration: float) -> void:
	%CountdownLabel.show()
	%CountdownTimer.start(duration)
	
	%GhostTint.show()


func on_returned_to_host() -> void:
	%CountdownLabel.hide()
	
	%GhostTint.hide()


func on_health_updated(health: int) -> void:
	%HealthLabel.text = str(health)
	
	if health <= 1:
		%BloodEffect.show()
	else:
		%BloodEffect.hide()
